namespace :seed do
  desc 'Export books to algolia service'
  task :server_bak, [:environment] do
    require_relative '../config/boot'
    require_relative '../lib/ett_api'
    require 'json'
    JSON
      .parse(File.read('./rakelib/seed/server_bak.json'))
      .map do |id|
        begin
          PlayerPersistor.new.call(id)
        rescue Hanami::Model::UniqueConstraintViolationError => e
          puts 'already exists'
        end
        sleep 1
      end
  end

  task :bonsai, [:environment] do
    require_relative '../config/boot'
    require_relative '../lib/ett_api'

    require 'csv'

    CSV
      .parse(File.read('./rakelib/seed/bonsaisliste.csv'))
      .map { |_, id, _, _, _| PlayerPersistor.new.call(id) }
  end

  task :clear_leagues, [:environment] do
    require_relative '../config/boot'
    require_relative '../lib/ett_api'
    require_relative '../lib/challonge'
    TournamentMembershipRepository
      .new
      .all
      .map { |e| TournamentMembershipRepository.new.delete(e.id) }

    TournamentRepository
      .new
      .all
      .map { |e| TournamentRepository.new.delete(e.id) }
  end

  task :leagues, [:environment] do
    require_relative '../config/boot'
    require_relative '../lib/ett_api'
    require_relative '../lib/challonge'
    require 'csv'

    utf8_file =
      File
        .read('./rakelib/seed/FBLigen2.utf8.csv')

    league_players_csv =
      CSV.parse(utf8_file, headers: true, col_sep: ';').map(&:to_h)

    CSV
      .parse(File.read('./rakelib/seed/Ligen.csv'), headers: true, col_sep: ';')
      .map do |row|
        p row['rank']
        puts "Creating tournament #{row['short_name']}"
        members =
          league_players_csv.filter do |pl|
            pl['Einteilung'] == row['short_name'].upcase
          end

        member_ids = members.map { |pl| pl['ID'] }

        p row['challonge_url']
        TournamentPersistor.new.call(
          {
            challonge_url: row['challonge_url'],
            short_name: row['short_name'],
            name: row['name'],
            color_hex: row['color_hex'],
            rank: row['rank'],
            member_ett_ids: member_ids
          }
        )
      end
  end
end
