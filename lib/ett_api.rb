require 'faraday'
require 'oj'

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
#   ]
# }

class LogCollectorAPI
  class << self
    SNAPSHOT_URL =
      'http://elevenlogcollector-env.js6z6tixhb.us-west-2.elasticbeanstalk.com/ElevenServerLiteSnapshot'
    def fetch_status
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
    def fetch_player(id_or_name)
      resp =
        Faraday.get(
          "https://www.elevenvr.club/accounts/#{id_or_name}"
        ) { |conn| conn.headers['Content-Type'] = 'application/json' }

      raise StandardError unless resp.status == 200

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
