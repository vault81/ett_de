require 'ett_api'

class RefreshPlayers
  class << self
    def run
      loop do
        puts 'Refreshing all players....'
        repo.all.map do |player|
          puts player

          attrs = EttAPI.fetch_player(player.ett_id)

          repo.update(player.id, attrs)
          sleep 2
        end
        puts 'Sleeping 1 minute'

        sleep 60
      end
    end

    private

    def repo
      PlayerRepository.new
    end
  end
end
