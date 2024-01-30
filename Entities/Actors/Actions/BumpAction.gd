extends ActionWithDirection

class_name BumpAction

func _init(entity: Entity, dx: int, dy: int).(entity, dx, dy) -> void:
	pass

func perform() -> void:
	self.entity.emit_signal(\
		"action_request", entity, "Bump", self.offset) 
