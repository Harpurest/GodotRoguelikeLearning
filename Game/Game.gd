class_name Game
extends Node2D

var player_grid_pos := Vector2.ZERO

onready var input_handler: InputHandler = $InputHandler

const player_definition: EntityDefinition = \
	preload("res://Assets/Definitions/Entities/Actors/entity_definition_player.tres")

onready var player: Entity
onready var map: Map = $Map

func _ready() -> void:
	player = Entity.new(Vector2.ZERO, player_definition)
	var camera: Camera2D = Camera2D.new()
	camera.current = true
	camera.zoom = Vector2(0.5,0.5)
	player.add_child(camera)
	map.generate(player)
	player.connect("action_request", self, "_on_action_request");
	map.update_fov(player.grid_position)

func _physics_process(delta: float) -> void:
	var action: Action = input_handler.get_action(player)
	if action:
		print_debug("Start Action")
		action.perform();
		print_debug("Finish Action")
		#_try_action(action, player)
		_handle_enemy_turns()

func get_map_data():
	return map.map_data

func _handle_enemy_turns() -> void:
	for entity in get_map_data().entities:
		if entity == player:
			continue
		print("The %s wonders when it will get to take a real turn." % entity.get_entity_name())

func _on_action_request(actor: Entity, type: String, dir: Vector2) -> void:
	print_debug("Perform Action")
	if type == "Bump":
		var destination = actor.grid_position + dir
		var target = get_map_data().get_blocking_entity_at_location(destination)
		if target:
			MeleeAction.new(actor, dir.x, dir.y)\
			.set_target(target)\
			.perform()
		else:
			var destination_tile: Tile = get_map_data().get_tile(actor.grid_position + dir)
			if not destination_tile or not destination_tile.is_walkable():
				return
			MovementAction.new(actor, dir.x, dir.y).perform()
			map.update_fov(player.grid_position)
