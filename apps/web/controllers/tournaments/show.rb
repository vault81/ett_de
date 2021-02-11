module Web
  module Controllers
    module Tournaments
      class Show
        include Web::Action

        expose :tournament

        def call(params)
          @tournament =
            TournamentRepository.new.find_with_relations(params[:id])
        end
      end
    end
  end
end
