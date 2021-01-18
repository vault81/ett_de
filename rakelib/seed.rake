require 'csv'
namespace :seed do
  desc 'Export books to algolia service'
  task :bonsai, [:environment] do
    require_relative '../config/boot'
    require_relative '../lib/ett_api'
    CSV
      .parse(File.read('./rakelib/seed/bonsaisliste.csv'))
      .map do |_, id, _, _, _|
        params = EttAPI.fetch_player(id)
        PlayerRepository.new.create(params)
      end
  end
end
