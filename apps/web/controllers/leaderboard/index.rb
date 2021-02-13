module Web
  module Controllers
    module Leaderboard
      class Index
        include Web::Action

        expose :players
        expose :match_infos

        params Class.new(Hanami::Action::Params) {
                 predicate(:validorder, message: 'is not cool') do |current|
                   break false unless current.is_a?(Array)
                   current.any? do |c|
                     %w[
                       ett_elo
                       ett_wins
                       ett_losses
                       ett_status
                       ett_last_online
                       league
                     ].include?(c)
                   end
                 end

                 validations { optional(:order) { validorder } }
               }

        def call(params)
          if params.valid?
            @players = ordered_players
            @match_infos = MatchInfoRepository.new.all
          else
            redirect_to '/leaderboard'
          end
        end

        private

        def ordered_players
          return league_ordered_players if params[:order]&.include?('league')
          order = params[:order]&.map { |p| p.to_sym }
          order << :ett_elo unless order.nil?

          players = PlayerRepository.new.all_in_order(order || [:ett_elo])
          players.reverse! if params[:order]&.include?('ett_status')
          players
        end

        def league_ordered_players
          players = PlayerRepository.new.all_with_tournaments

          players.sort_by do |player|
            [
              player.tournaments.first&.rank || 999_999_999,
              -player.ett_elo.to_i,
              player.ett_name
            ]
          end
        end
      end
    end
  end
end
