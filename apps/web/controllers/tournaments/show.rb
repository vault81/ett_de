module Web
  module Controllers
    module Tournaments
      class Show
        include Web::Action
        ID_MAPPING={
          7 => 1,
          8 => 2,
          9 => 3,
          10 => 4,
          11 => 5,
          12 => 6,
        }

        expose :tournament

        def call(params)
          mapped_id=ID_MAPPING[params[:id]
          @tournament =
            TournamentRepository.new.find_with_relations(mapped_id || params[:id])
        end
      end
    end
  end
end
