class_name HostileEnemyAIComponent
extends BaseAIComponent

func perform() -> void:
	var offset: Vector2 = target_offset - actor_offset
	var distance: int = max(abs(offset.x), abs(offset.y))

	if distance <= 1:
		emit_signal("react_action", "Melee", offset)
		return
	
	if path.size() == 0:
		path = pathfinder.get_point_path(
			Grid.calculate_point_index(actor_offset),
			Grid.calculate_point_index(target_offset)
		)
		path.pop_front()
	
	if path.size() > 0:
		var destination := Vector2(path[0])
		var bump_offset: Vector2 = destination - actor_offset
		emit_signal("react_action", "Bump", bump_offset)
		return
	
	emit_signal("react_action", "Wait", Vector2(0,0))
