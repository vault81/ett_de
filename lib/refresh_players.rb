require 'ett_api'
require 'challonge'

class RefreshPlayers
  class << self
    def run_challonge
      new.run_challonge
    rescue StandardError => e
      log_error(e)
      sleep 120
      run_challonge
    end

    def run_log
      new.run_log
    rescue StandardError => e
      log_error(e)
      sleep 120
      run_log
    end

    def run
      new.run
    rescue StandardError => e
      log_error(e)
      sleep 300
      run
    end

    def log_error(e)
      puts "Error: #{e}"
      puts "Backtrace: #{e.backtrace.join("\n")}"
    end
  end

  def initialize
    @log = {}
  end

  def run_log
    loop do
      @log = LogCollectorAPI.fetch_log
      puts 'Refreshing all player loges....'
      repo.all.map do |player|
        puts player

        attrs = { ett_status: build_log_for_player(player.ett_id) }
        puts attrs
        repo.update(player.id, attrs)

        attrs = find_match(player.ett_id)
        p attrs
        MatchInfoRepository.new.update_or_create(player.id, test: attrs)
      end
      puts 'Sleeping 15 secs'
      sleep 15
    end
  end

  def run
    loop do
      puts 'Refreshing all players....'

      @log = LogCollectorAPI.fetch_log
      repo.all.map do |player|
        puts player

        attrs = EttAPI.fetch_player(player.ett_id)
        attrs = attrs.merge(ett_status: build_log_for_player(player.ett_id))
        puts attrs

        repo.update(player.id, attrs)
        sleep 1
      end
      puts 'Sleeping 5 minutes'

      sleep 60 * 5
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
    tournament = persist_tournament(resp[:tournament])
    persist_tournament_memberships(resp[:tournament][:participants], tournament)
  end

  private

  attr_reader :log

  def persist_tournament(resp)
    TournamentRepository.new.update_or_create(
      resp[:id],
      { challonge_state: resp[:state] }
    )
  end

  def persist_tournament_memberships(participants_resp, tournament)
    participants_resp.map { |e| e[:participant] }.map do |part|
      pp '------------'
      pp part[:display_name].split(' ').first
      player =
        PlayerRepository.new.find_by_ett_name(
          part[:display_name].split(' ').first
        )

      next if player.nil?
      pp '================'
      TournamentMembershipRepository.new.find_or_create(
        player.id,
        tournament.id
      )
    end
  end

  def build_log_for_player(id)
    return 'broken ' if log[:OnlineUses].nil?
    return 'offline' unless log[:OnlineUses].any? { |el| el[:Id] == id.to_s }
    return 'free' unless log[:UsersInRooms].any? { |el| el[:Id] == id.to_s }

    'inroom'
  end

  def find_match(id)
    return {} if log[:ActiveMatches].nil?
    match =
      log[:ActiveMatches].find do |match|
        match[:HomePlayer][:Id] == id.to_s || match[:AwayPlayer][:Id] == id.to_s
      end
    return {} if match.nil?

    player_state = (match[:HomePlayer][:Id] == id.to_s) ? 'home' : 'away'
    rounds =
      match[:Rounds].sort_by { |round| round[:RoundNumber] }.map do |round|
        round.slice(:HomeScore, :AwayScore)
      end

    {
      player_state: player_state,
      home_player_id: match[:HomePlayer][:Id],
      home_player_name: match[:HomePlayer][:UserName],
      away_player_id: match[:AwayPlayer][:Id],
      away_player_name: match[:AwayPlayer][:UserName],
      rounds_count: match[:Rounds].count,
      rounds: rounds
    }
  end

  def repo
    PlayerRepository.new
  end
end
