class Player < Hanami::Entity
  attributes do
    # @!attribute id
    #   @return [Integer]
    attribute :id, Types::Int

    # @!attribute ett_last_online
    #   @return [Time]
    attribute :ett_last_online, Types::Time

    # @!attribute ett_status
    #   @return [String]
    attribute :ett_status, Types::String

    # @!attribute ett_id
    #   @return [Integer]
    attribute :ett_id, Types::Int

    # @!attribute ett_name
    #   @return [String]
    attribute :ett_name, Types::String

    # @!attribute ett_elo
    #   @return [Integer]
    attribute :ett_elo, Types::Int

    # @!attribute ett_wins
    #   @return [Integer]
    attribute :ett_wins, Types::Int

    # @!attribute ett_losses
    #   @return [Integer]
    attribute :ett_losses, Types::Int

    # @!attribute ett_rank
    #   @return [Integer]
    attribute :ett_rank, Types::Int

    # @!attribute created_at
    #   @return [Time]
    attribute :created_at, Types::Time

    # @!attribute updated_at
    #   @return [Time]
    attribute :updated_at, Types::Time
  end
end
