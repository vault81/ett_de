module Web
  module Views
    module Leaderboard
      class Index
        include Web::View

        def format_rank(rank)
          case rank
          when 1
            '🥇'
          when 2
            '🥈'
          when 3
            '🥉'
          else
            "#{rank}"
          end
        end

        def league_color(league)
          color =
            case league&.rank
            when 1
              '329932'
            when 2
              '4ca64c'
            when 3
              '66b266'
            when 4
              'add8e6'
            when 5
              '9bc2cf'
            when 6
              '8aacb8'
            when 7
              '7997a1'
            when 8
              '67818a'
            else
              return ''
            end

          "background-color: \##{color};"
        end

        # def div
        def collapse(id, &block)
          button(
            'show',
            {
              class: 'btn-small small rounded-pill btn-secondary',
              type: 'button',
              "data-bs-toggle": 'collapse',
              "data-bs-target": "collapse-#{id}"
            }
          )
          div(class: 'collapse', id: "collapse-#{id}") { yield }
        end

        # end
        def format_matchup(match_info)
          if match_info[:player_state] == 'home'
            %w[bg-success bg-warning]
          else
            %w[bg-warning bg-success]
          end
        end

        def format_round(round)
          case round[:HomeScore] <=> round[:AwayScore]
          when 1
            left_cl = 'bg-success'
            right_cl = 'bg-danger'
          when 0
            left_cl = 'bg-warning'
            right_cl = 'bg-warning'
          when -1
            left_cl = 'bg-danger'
            right_cl = 'bg-success'
          end

          { left_cl: left_cl, right_cl: right_cl }
        end

        def format_time(time_in_s)
          days = (time_in_s / (3600 * 24))
          time_in_s = (time_in_s % (3600 * 24))

          h = (time_in_s / 3600)
          time_in_s = time_in_s % 3600

          min = time_in_s / 60
          sek = time_in_s % 60

          str = "#{h}h #{min}min #{sek}s"
          str = "#{days}d " + str if days != 0
          "vor #{str}"
        end
      end
    end
  end
end
