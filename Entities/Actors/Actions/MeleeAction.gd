class_name MeleeAction
extends ActionWithDirection

var target: Entity

func _init(entity: Entity, dx: int, dy: int).(entity, dx, dy) -> void:
	pass

func perform() -> void:
	print("You kick the %s, much to it's annoyance!" % target.get_entity_name())

func set_target(object: Entity) -> MeleeAction:
	self.target = object
	return self
