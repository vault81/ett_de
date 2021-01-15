require 'faraday'

module Web
  module Controllers
    module Players
      class Create
        include Web::Action

        def call(params)
          params = get_player_data(params[:player][:ett_id])
          PlayerRepository.new.create(params)

          redirect_to '/leaderboard'
        end

        def get_player_data(ett_id)
          attrs = fetch_from_ett_api(ett_id)

          {
            ett_id: attrs[:ett_id],
            ett_name: attrs[:"user-name"],
            ett_wins: attrs[:wins],
            ett_losses: attrs[:losses],
            ett_rank: attrs[:rank],
            ett_elo: attrs[:elo]
          }
        end

        def fetch_from_ett_api(ett_id)
          resp =
            Faraday.get(
              "https://www.elevenvr.club/accounts/#{ett_id}"
            ) { |conn| conn.headers['Content-Type'] = 'application/json' }
          data = Oj.load(resp.body, symbol_keys: true)[:data]
          data[:attributes].merge(ett_id: data[:id])
        end
      end
    end
  end
end
