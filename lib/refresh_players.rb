require 'ett_api'

class RefreshPlayers
  class << self
    def run
      loop do
        puts 'Refreshing all players....'

        status = LogCollectorAPI.fetch_status
        repo.all.map do |player|
          puts player

          attrs = EttAPI.fetch_player(player.ett_id)
          attrs =
            attrs.merge(
              ett_status: build_status_for_player(player.ett_id, status)
            )
          puts attrs

          repo.update(player.id, attrs)
          sleep 1
        end
        puts 'Sleeping 5 minutes'

        sleep 60 * 5
      end
    end

    def build_status_for_player(id, status)
      return 'offline' unless status[:OnlineUses].any? { |el| el[:Id] == id.to_s }
      return 'free' unless status[:UsersInRooms].any? { |el| el[:Id] == id.to_s }

      'inroom'
    end

    private

    def repo
      PlayerRepository.new
    end
  end
end
