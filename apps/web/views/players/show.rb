module Web
  module Views
    module Players
      class Show
        include Web::View
        def invert_key(key, query_hash)
          query_hash = query_hash.dup
          if query_hash[key].nil?
            query_hash.merge!(key => '1')
          else
            query_hash.delete(key)
          end
          query_hash
        end

        def res_link(args)
          args_str = args.map { |k, v| "#{k}=#{v}" }.join('&')

          "?#{args_str}"
        end

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

        def titleize(str)
          Hanami::Utils::String.titleize(str)
        end

        def make_table(hash)
          body =
            hash.map { |k, v| "<th>\n<tr>#{k}</tr><tr>#{v}</tr>\n</th>" }.join(
              '/n'
            )

          "<table>#{body}</table>"
        end
      end
    end
  end
end
