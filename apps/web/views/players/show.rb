module Web
  module Views
    module Players
      class Show
        include Web::View
        def titleize(str)
          Hanami::Utils::String.titleize(str)
        end

        def make_table(hash)
          body =
            hash.map { |k, v| "<th>\n<tr>#{k}</tr><tr>#{v}</tr>\n</th>" }.join(
              "/n"
            )

          "<table>#{body}</table>"
        end
      end
    end
  end
end
