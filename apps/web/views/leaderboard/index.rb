module Web
  module Views
    module Leaderboard
      class Index
        include Web::View

        def format_time(time_in_s)
          days = (time_in_s / (3600 * 24))
          time_in_s = (time_in_s % (3600 * 24))

          h = (time_in_s / 3600)
          time_in_s = time_in_s % 3600

          min = time_in_s / 60
          sek = time_in_s % 60

          str = "#{h}h #{min}min #{sek}s"
          str = "#{days}d " + str if days != 0
          str
        end
      end
    end
  end
end
