require 'ett_api'

module Web
  module Controllers
    module Players
      class Create
        include Web::Action

        def call(params)
          params = get_player_data(params[:player][:ett_id_or_name])
          PlayerRepository.new.create(params)

          redirect_to '/leaderboard'
        end

        def get_player_data(ett_id)
          EttAPI.fetch_player(ett_id)
        end
      end
    end
  end
end