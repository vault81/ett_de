require 'faraday'

class EttAPI
  class << self
    def fetch_player(id_or_name)
      resp =
        Faraday.get(
          "https://www.elevenvr.club/accounts/#{id_or_name}"
        ) { |conn| conn.headers['Content-Type'] = 'application/json' }

      data = Oj.load(resp.body, symbol_keys: true)[:data]
      attrs = data[:attributes].merge(ett_id: data[:id])

      {
        ett_id: attrs[:ett_id],
        ett_name: attrs[:"user-name"],
        ett_wins: attrs[:wins],
        ett_losses: attrs[:losses],
        ett_rank: attrs[:rank],
        ett_elo: attrs[:elo]
      }
    end
  end
end
