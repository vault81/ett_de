module Web
  module Views
    module Tournaments
      class Show
        include Web::View
        def titleize(str)
          Hanami::Utils::String.titleize(str)
        end
      end
    end
  end
end
