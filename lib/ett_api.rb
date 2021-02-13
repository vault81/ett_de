require 'faraday'
require 'oj'

class LogCollectorAPI
  # Example Log:
  # ```
  # {
  #   "OnlineUsers": [
  #     {
  #       "UserName": 'wanderingspy23',
  #       "Device": 'Oculus Quest 2',
  #       "Platform": 'OCULUS',
  #       "ELO": '1486',
  #       "Id": '245061'
  #     }
  #   ],
  #   "UsersInRoom": [
  #     {
  #       "UserName": 'RGKING92',
  #       "Device": 'Oculus Quest',
  #       "Platform": 'OCULUS',
  #       "ELO": '1491',
  #       "Id": '269377'
  #     }
  #   ],
  #   "Rooms": [
  #     {
  #       "CreatedAt": '01/15/2021 16:35:06',
  #       "Players": [
  #         {
  #           "UserName": 'krishh',
  #           "Device": 'Oculus Quest',
  #           "Platform": 'OCULUS',
  #           "ELO": '1629',
  #           "Id": '20651'
  #         },
  #         {
  #           "UserName": 'flvikky',
  #           "Device": 'Oculus Quest 2',
  #           "Platform": 'OCULUS',
  #           "ELO": '1490',
  #           "Id": '150929'
  #         }
  #       ]
  #     }
  #   ],
  #   "ActiveMatches": {
  #     "Ranked": false,
  #     "HomeScore": 0,
  #     "AwayScore": 0,
  #     "HomePlayer": {
  #       "UserName": 'zitoun31',
  #       "Device": 'Oculus Quest 2',
  #       "Platform": 'OCULUS',
  #       "ELO": '1484',
  #       "Id": '177910'
  #     },
  #     "AwayPlayer": {
  #       "UserName": 'zitinvit',
  #       "Device": 'Oculus Quest',
  #       "Platform": 'OCULUS',
  #       "ELO": '1516',
  #       "Id": '177909'
  #     },
  #     "Rounds": [
  #       {
  #         "CreatedAt": '01/15/2021 20:45:57',
  #         "RoundNumber": 0,
  #         "HomeScore": 3,
  #         "AwayScore": 1,
  #         "Winner": -1
  #       }
  #     ]
  #   }
  # }
  # ```

  class << self
    SNAPSHOT_URL =
      'http://elevenlogcollector-env.js6z6tixhb.us-west-2.elasticbeanstalk.com/ElevenServerLiteSnapshot'
        .freeze

    # @return [Hash]
    def fetch_log
      resp =
        Faraday.get(SNAPSHOT_URL) do |conn|
          conn.headers['Content-Type'] = 'application/json'
        end
      Oj.load(resp.body, symbol_keys: true)
    end
  end
end

class EttAPI
  class << self
    # @param id_or_name [Integer, String]
    # @return [Hash]
    def fetch_player(id_or_name)
      resp = get_player(id_or_name)
      p resp.class

      raise StandardError unless resp.status == 200

      data = Oj.load(resp.body, symbol_keys: true)[:data]
      attrs = data[:attributes].merge(ett_id: data[:id])

      build_return_hash(attrs)
    end

    private

    def build_return_hash(attrs)
      {
        ett_last_online: Time.parse(attrs[:"last-online"]),
        ett_id: attrs[:ett_id],
        ett_name: attrs[:"user-name"],
        ett_wins: attrs[:wins],
        ett_losses: attrs[:losses],
        ett_rank: attrs[:rank],
        ett_elo: attrs[:elo]
      }
    end

    # @param id_or_name [Integer, String]
    # @return [Faraday::Response]
    def get_player(id_or_name)
      Faraday.get("https://www.elevenvr.club/accounts/#{id_or_name}") do |conn|
        conn.headers['Content-Type'] = 'application/json'
      end
    end
  end
end
