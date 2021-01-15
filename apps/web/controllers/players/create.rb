require 'ett_api'

module Web
  module Controllers
    module Players
      class Create
        include Web::Action

        def call(params)
          params = EttAPI.fetch_player(params[:player][:ett_id_or_name])
          PlayerRepository.new.create(params)

          redirect_to '/leaderboard'
        end

        def get_player_data(ett_id); end
      end
    end
  end
end
