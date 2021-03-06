require 'appsignal'
require 'ett_api'
require 'challonge'

class RefreshPlayers
  class << self
    def run_challonge
      monitor(:challonge) do
        new.run_challonge

        puts 'Sleeping 6 secs'
        sleep 6
      end
    end

    def run_log
      monitor(:log) do
        new.run_log

        puts 'Sleeping 6 secs'
        sleep 6
      end
    end

    def run_matches
      monitor(:matches) do
        new.run_matches

        puts 'Sleeping 6 secs'
        sleep 6
      end
    end

    def run
      monitor(:players) do
        new.run

        puts 'Sleeping 30 secs'
        sleep 30
      end
    end

    private

    def monitor(name = 'default', &block)
      begin
        loop { Appsignal.instrument("worker.#{name}") { yield } }
      rescue StandardError => e
        log_error(e)
        sleep 60
        monitor(&block)
      end
    end

    def log_error(e)
      puts "Error: #{e}"
      puts "Backtrace: #{e.backtrace.join("\n")}"

      Appsignal.set_error(e)
    end
  end

  def initialize
    @log = {}
  end

  def run_matches
    repo.all.map do |player|
      Thread.new do
        attrs = EttAPI.fetch_matches(player.ett_id)

        MatchInfoRepository.new.update_or_create(player.id, test: attrs)
      end
    end.map do |thr|
      thr.join
      sleep 0.1
    end
  end

  def run_log
    self.log = LogCollectorAPI.fetch_log
    puts 'Refreshing all player loges....'
    repo.all.map do |player|
      puts player

      attrs = { ett_status: build_log_for_player(player.ett_id) }
      puts attrs
      repo.update(player.id, attrs)

      attrs = build_match(player.ett_id)
      next if attrs.nil?
      MatchInfoRepository.new.update_or_create(player.id, test: attrs)
    end
  end

  def run
    puts 'Refreshing all players....'

    repo.all.map do |player|
      attrs = EttAPI.fetch_player(player.ett_id)

      repo.update(player.id, attrs)
      sleep 1
    end
  end

  def run_challonge
    TournamentRepository
      .new
      .all
      .map { |tournament| refresh_tournament(tournament.challonge_url) }
  end

  def refresh_tournament(url = '11_GER_ibtnaetx')
    resp = Challonge.new.get(url)
    persist_tournament(resp[:tournament])
    # persist_tournament_memberships(resp[:tournament][:participants], tournament)
  end

  private

  attr_accessor :log

  def persist_tournament(resp)
    TournamentRepository.new.update_or_create(
      resp[:id],
      { challonge_state: resp[:state] }
    )
  end

  # rubocop:disable Metrics/MethodLength
  def persist_tournament_memberships(participants_resp, tournament)
    participants_resp.map { |e| e[:participant] }.map do |part|
      player =
        PlayerRepository.new.find_by_ett_name(
          part[:display_name].split(' ').first
        )

      next if player.nil?

      TournamentMembershipRepository.new.find_or_create(
        player.id,
        tournament.id
      )
    end
  end

  # rubocop:enable Metrics/MethodLength

  def build_log_for_player(id)
    return 'broken ' if log[:OnlineUses].nil?
    return 'offline' unless log[:OnlineUses].any? { |el| el[:Id] == id.to_s }
    return 'free' unless log[:UsersInRooms].any? { |el| el[:Id] == id.to_s }

    'inroom'
  end

  # rubocop:disable Metrics/MethodLength
  def build_match(id)
    match = find_match(id)
    return nil if match.nil?

    rounds = build_rounds(match)

    {
      match_ranked: match[:Ranked],
      match_state: 'ongoing',
      player_state: match[:HomePlayer][:Id] == id.to_s ? 'home' : 'away',
      home_player_id: match[:HomePlayer][:Id],
      home_player_name: match[:HomePlayer][:UserName],
      home_player_platform: match[:HomePlayer][:Platform],
      home_player_device: match[:HomePlayer][:Device],
      away_player_id: match[:AwayPlayer][:Id],
      away_player_name: match[:AwayPlayer][:UserName],
      away_player_device: match[:AwayPlayer][:Device],
      away_player_platform: match[:AwayPlayer][:Platform],
      rounds_count: match[:Rounds].count,
      rounds: rounds
    }
  end

  # rubocop:enable Metrics/MethodLength

  def find_match(id)
    return nil if log[:ActiveMatches].nil?

    log[:ActiveMatches].find do |match|
      match[:HomePlayer][:Id] == id.to_s || match[:AwayPlayer][:Id] == id.to_s
    end
  end

  def build_rounds(match)
    match[:Rounds].sort_by { |round| round[:RoundNumber] }.map do |round|
      round.slice(:HomeScore, :AwayScore)
    end
  end

  def repo
    PlayerRepository.new
  end
end
