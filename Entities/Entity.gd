class_name Entity
extends Sprite

signal action_request(actor, action_type, dir)
signal ai_action_request(actor, action_type, dir)
signal move(old_position, new_position)

var grid_position: Vector2
var _definition: EntityDefinition

enum AIType {NONE = 0, HOSTILE = 1}
var fighter_component: FighterComponent
var ai_component: BaseAIComponent

func set_grid_position(value: Vector2) -> void:
	self.grid_position = value
	self.position = Grid.grid_to_world(self.grid_position)

func get_grid_position() -> Vector2:
	return self.grid_position

func _init(start_position: Vector2, entity_definition: EntityDefinition) -> void:
	centered = false
	set_grid_position(start_position)
	set_entity_type(entity_definition)
	z_index = 1

func move(dir: Vector2) -> void:
	var old_position = self.grid_position;
	set_grid_position(self.grid_position + dir)
	var new_position = self.grid_position;
	emit_signal("move", old_position, new_position)

func set_entity_type(entity_definition: EntityDefinition) -> void:
	_definition = entity_definition
	texture = entity_definition.texture
	modulate = entity_definition.color
	
	match entity_definition.ai_type:
		AIType.HOSTILE:
			ai_component = HostileEnemyAIComponent.new()
			add_child(ai_component)
			ai_component.connect("react_action", self, "_on_react_action")
	
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition)
		add_child(fighter_component)

func is_blocking_movement() -> bool:
	return _definition.is_blocking_movement

func get_entity_name() -> String:
	return _definition.name

func is_alive() -> bool:
	if _definition.name != "Player":
		return ai_component != null
	return true

func ai_perform(target_entity: Entity, pathfinder: AStar2D) -> void:
	pass

func _on_react_action(type, offset) -> void:
	pass
