module Web
  module Controllers
    module Tournaments
      class Show
        include Web::Action
        expose :tournament

        def call(params)
          @tournament =
            TournamentRepository.new.find_with_relations(params[:id])

          status 404, 'Not Found' if tournament.nil?
        end
      end
    end
  end
end
