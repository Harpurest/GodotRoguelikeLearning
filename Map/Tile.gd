class_name Tile
extends Sprite

var _definition: TileDefinition
var is_explored: bool = false
var is_in_view: bool = false


func _init(grid_position: Vector2, tile_definition: TileDefinition) -> void:
	visible = false
	centered = false
	position = Grid.grid_to_world(grid_position)
	set_tile_type(tile_definition)

func set_tile_type(tile_definition: TileDefinition) -> void:
	_definition = tile_definition
	texture = _definition.texture
	modulate = _definition.color_dark

func is_walkable() -> bool:
	return _definition.is_walkable

func is_transparent() -> bool:
	return _definition.is_transparent

func set_explore(value: bool) -> void:
	is_explored = value
	if is_explored and not visible:
		visible = true

func set_in_view(value: bool) -> void:
	is_in_view = value
	modulate = _definition.color_lit if is_in_view else _definition.color_dark
	if is_in_view and not is_explored:
		set_explore(true)
