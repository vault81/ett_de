module Web
  module Controllers
    module Leaderboard
      class Index
        include Web::Action

        expose :players

        def call(params)
          @players = PlayerRepository.new.all.sort_by(&:ett_elo).reverse
        end
      end
    end
  end
end
