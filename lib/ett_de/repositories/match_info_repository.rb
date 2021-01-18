class MatchInfoRepository < Hanami::Repository
  def update_or_create(player_id, attrs)
    entity = match_infos.where(player_id: player_id).one
    update(entity.id, attrs) && return unless entity.nil?
    create(attrs.merge(player_id: player_id))
  end
end
