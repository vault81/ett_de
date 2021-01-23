namespace :seed do
  desc 'Export books to algolia service'
  task :server_bak, [:environment] do
    require_relative '../config/boot'
    require_relative '../lib/ett_api'
    require 'json'
    JSON
      .parse(File.read('./rakelib/seed/server_bak.json'))
      .map do |id|
        params = EttAPI.fetch_player(id)
        begin
          PlayerRepository.new.create(params)
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
      .map do |_, id, _, _, _|
        params = EttAPI.fetch_player(id)
        PlayerRepository.new.create(params)
      end
  end
end
