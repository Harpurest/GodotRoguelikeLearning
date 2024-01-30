class_name MovementAction
extends ActionWithDirection

func _init(entity: Entity, dx: int, dy: int).(entity, dx, dy) -> void:
	pass

func perform() -> void:
	entity.move(offset)
	
