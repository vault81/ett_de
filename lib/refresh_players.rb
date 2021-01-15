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
          sleep 5
        end
        puts 'Sleeping 5 minutes'

        sleep 60 * 5
      end
    end

    private

    def repo
      PlayerRepository.new
    end
  end
end
