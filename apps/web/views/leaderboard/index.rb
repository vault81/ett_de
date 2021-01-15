module Web
  module Views
    module Leaderboard
      class Index
        include Web::View

        def format_time(time_in_s)
          h = (time_in_s / 3600)
          rest_s = time_in_s % 3600
          min = rest_s / 60
          sek = rest_s % 60

          "#{h} h #{min} min #{sek} s"
        end
      end
    end
  end
end
