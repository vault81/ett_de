require 'ett_api'

module Web
  module Controllers
    module Players
      class Create
        include Web::Action
        handle_exception Hanami::Model::UniqueConstraintViolationError => :handle_duplicate_error

        def call(params)
          params = EttAPI.fetch_player(params[:player][:ett_id_or_name])
          PlayerRepository.new.create(params)

          redirect_to '/leaderboard'
        end

        def handle_duplicate_error(_e)
          # status 403, exception.message
          redirect_to '/leaderboard'
        end
      end
    end
  end
end
