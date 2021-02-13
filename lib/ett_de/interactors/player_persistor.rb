require 'hanami/interactor'
require 'ett_api'

class PlayerPersistor
  include Hanami::Interactor

  def initialize; end

  # @param ett_id_or_name [Integer, String]
  # @return [Player]
  def call(ett_id_or_name)
    params = EttAPI.fetch_player(ett_id_or_name)
    PlayerRepository.new.update_or_create_by_ett_id(params)
  end
end
