require 'ett_api'

module Web
  module Controllers
    module Players
      class Create
        include Web::Action
        handle_exception Hanami::Model::UniqueConstraintViolationError =>
                           :handle_duplicate_error

        def call(params)
          PlayerPersistor.new.call(params[:ett_id_or_name])

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
