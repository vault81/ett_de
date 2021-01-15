module Web
  module Controllers
    module Leaderboard
      class Index
        include Web::Action

        expose :players

        def call(params)
          @players = PlayerRepository.new.all_by_elo
        end
      end
    end
  end
end
