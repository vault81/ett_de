module Web
  module Controllers
    module Leaderboard
      class Index
        include Web::Action

        expose :players
        expose :match_infos

        def call(params)
          @players = PlayerRepository.new.all_by_elo
          @match_infos = MatchInfoRepository.new.all
        end
      end
    end
  end
end
