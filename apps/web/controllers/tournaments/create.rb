module Web
  module Controllers
    module Tournaments
      class Create
        include Web::Action
        handle_exception Hanami::Model::UniqueConstraintViolationError =>
                           :handle_duplicate_error

        def call(params)
          url = params[:tournament][:challonge_url]
          resp = Challonge.new.get(url)
          TournamentRepository.new.update_or_create(
            resp[:tournament][:id],
            {
              short_name: params[:tournament][:short_name],
              name: params[:tournament][:name],
              rank: params[:tournament][:rank],
              color_hex: params[:tournament][:color_hex],
              challonge_url: url,
              challonge_state: resp[:tournament][:state]
            }
          )

          RefreshPlayers.new.refresh_tournament(
            params[:tournament][:challonge_url]
          )

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
