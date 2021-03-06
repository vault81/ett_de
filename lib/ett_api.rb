require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response_middleware'
require 'oj'

class LogCollectorAPI
  class << self
    SNAPSHOT_URL =
      'http://elevenlogcollector-env.js6z6tixhb.us-west-2.elasticbeanstalk.com/ElevenServerLiteSnapshot'
        .freeze

    # @return [Hash]
    def fetch_log
      resp =
        Faraday.get(SNAPSHOT_URL) do |conn|
          conn.headers['Content-Type'] = 'application/json'
        end
      Oj.load(resp.body, symbol_keys: true)
    end
  end
end

class EttAPI
  class APIError < StandardError
  end
  class ParseETTApi < FaradayMiddleware::ResponseMiddleware
    dependency { require 'json' unless defined?(::JSON) }

    define_parser do |body, parser_options|
      return if body.strip.empty?
      parsed = ::JSON.parse(body, parser_options || {})
      fix_value(parsed)
    end

    class << self
      private

      def fix_value(val)
        return fix_hash(val) if val.is_a?(Hash)
        return fix_arr(val) if val.is_a?(Array)
        val
      end

      def fix_hash(val)
        val.map { |k, v| [fix_key(k), fix_value(v)] }.to_h
      end

      def fix_arr(val)
        val.map { |el| fix_value(el) }
      end

      def fix_key(key)
        key.to_s.tr('-', '_')
      end
    end
  end

  Faraday::Response.register_middleware(ett_api: -> { ParseETTApi })

  class Base < SimpleJSONAPIClient::Base
  end

  class UserMatches < Base
    COLLECTION_URL = '/accounts/%{account_id}/matches?page[size]=1'
    TYPE = 'matches'

    attributes :ranked
    attributes :state
    attributes :home_user_id
    attributes :away_user_id
    attributes :elo_change
    attributes :home_elo
    attributes :away_elo
    attributes :home_team
    attributes :away_team

    has_many :rounds, class_name: 'EttAPI::Round'
  end

  class Round < Base
    TYPE = 'rounds'

    attributes :state
    attributes :winner
    attributes :round_number
    attributes :home_score
    attributes :away_score
  end

  class << self
    # @param id_or_name [Integer, String]
    # @return [Hash]
    def fetch_player(id_or_name)
      resp = get_player(id_or_name)
      raise APIError unless resp.status == 200

      data = Oj.load(resp.body, symbol_keys: true)[:data]
      attrs = data[:attributes]

      build_return_hash(attrs)
    end

    # @param id [Integer]
    # @return [Hash]
    def fetch_matches(id)
      last_match =
        UserMatches.fetch_all(
          connection: connection,
          url_opts: {
            account_id: id
          }
        ).first
      build_match_info(last_match, id)
    end

    private

    def build_match_info(match, id)
      return {} if match.nil?

      rounds = build_rounds(match.rounds)

      {
        match_ranked: match.ranked,
        match_state: match.state == 1 ? 'done' : 'ongoing',
        player_state: match.home_user_id == id ? 'home' : 'away',
        home_player_id: match.home_user_id,
        home_player_name: match.home_team.first['UserName'],
        home_player_elo: match.home_elo,
        away_player_id: match.away_user_id,
        away_player_name: match.away_team.first['UserName'],
        away_player_elo: match.away_elo,
        rounds_count: match.rounds.count,
        rounds: rounds
      }
    end

    def build_rounds(rounds)
      rounds.map do |round|
        { HomeScore: round.home_score, AwayScore: round.away_score }
      end
    end

    def build_return_hash(attrs)
      {
        ett_last_online: Time.parse(attrs[:"last-online"]),
        ett_id: attrs[:ett_id],
        ett_name: attrs[:"user-name"],
        ett_wins: attrs[:wins],
        ett_losses: attrs[:losses],
        ett_rank: attrs[:rank],
        ett_elo: attrs[:elo]
      }
    end

    # @param id_or_name [Integer, String]
    # @return [Faraday::Response]
    def get_player(id_or_name)
      conn.get("/accounts/#{id_or_name}")
    end

    def conn
      Faraday.new('https://www.elevenvr.club') do |conn|
        conn.headers['Content-Type'] = 'application/json'
      end
    end

    def connection
      default_headers = {
        'User-Agent' => 'https://ett.vlt81.de/leaderboard Ruby App Server',
        'Content-Type' => 'application/json'
      }

      @connection ||=
        Faraday.new(
          url: 'https://www.elevenvr.club',
          headers: default_headers
        ) do |connection|
          connection.request :json
          connection.response :ett_api
          connection.adapter :net_http
        end
    end
  end
end
