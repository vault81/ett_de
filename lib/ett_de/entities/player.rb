class Player < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :ett_status, Types::String
    attribute :ett_id, Types::Int
    attribute :ett_name, Types::String
    attribute :ett_elo, Types::Int
    attribute :ett_wins, Types::Int
    attribute :ett_losses, Types::Int
    attribute :ett_rank, Types::Int
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
