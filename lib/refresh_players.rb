require 'ett_api'

class RefreshPlayers
  class << self
    def run_status
      loop do
        puts 'Refreshing all player statuses....'
        repo.all.map do |player|
          puts player

          attrs = { ett_status: build_status_for_player(player.ett_id, status) }
          puts attrs

          repo.update(player.id, attrs)
        end
        sleep 5
      end
    end

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
      unless status[:OnlineUses].any? { |el| el[:Id] == id.to_s }
        return 'offline'
      end
      unless status[:UsersInRooms].any? { |el| el[:Id] == id.to_s }
        return 'free'
      end

      'inroom'
    end

    private

    def repo
      PlayerRepository.new
    end
  end
end
