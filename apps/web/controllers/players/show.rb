module Web
  module Controllers
    module Players
      class Show
        include Web::Action

        expose :player

        def call(params)
          @player = PlayerRepository.new.find_with_relations(params[:id])

          status 404, 'Not Found' if player.nil?
        end
      end
    end
  end
end
