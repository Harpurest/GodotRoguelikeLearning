class_name DungeonGenerator
extends Node

export var map_width: int = 80
export var map_height: int = 45

export var max_rooms: int = 30
export var room_max_size: int = 10
export var room_min_size: int = 6

export var max_monsters_per_room = 2

var _rng := RandomNumberGenerator.new()
var Bresenham = preload("res://Utils/Bresenham.gd")

const entity_types = {
	"orc": preload("res://Assets/Definitions/Entities/Actors/entity_definition_orc.tres"),
	"troll": preload("res://Assets/Definitions/Entities/Actors/entity_definition_troll.tres"),
}

func _ready() -> void:
	_rng.randomize()

func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
		var tile_position = Vector2(x, y)
		var tile: Tile = dungeon.get_tile(tile_position)
		tile.set_tile_type(dungeon.tile_types.floor)

func _carve_room(dungeon: MapData, room: Rect2) -> void:
	var inner: Rect2 = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_carve_tile(dungeon, x, y)

func generate_dungeon(player: Entity) -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	dungeon.entities.append(player)
	var rooms: Array = []
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, dungeon.width - room_width - 1)
		var y: int = _rng.randi_range(0, dungeon.height - room_height - 1)
		
		var new_room := Rect2(x, y, room_width, room_height)
		
		var has_intersections := false
		for room in rooms:
			# Rect2i.intersects() checks for overlapping points. In order to allow bordering rooms one room is shrunk.
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		_carve_room(dungeon, new_room)
		
		if rooms.empty():
			var pos = new_room.get_center();
			var pos_x = int(pos.x);
			var pos_y = int(pos.y);
			player.set_grid_position(Vector2(pos_x, pos_y))
		else:
			_tunnel_between(dungeon, rooms.back().get_center(), new_room.get_center())

		_place_entities(dungeon, new_room)

		rooms.append(new_room)

	dungeon.setup_pathfinding()

	return dungeon

func _tunnel_between(dungeon: MapData, start: Vector2, end: Vector2) -> void:
	_rng.randomize()
	var rn = _rng.randf()
	var x_corner
	var y_corner
	if rn < 0.5:
		x_corner = end.x
		y_corner = start.y
	else:
		x_corner = start.x
		y_corner = end.y
	var corner = Vector2(x_corner, y_corner)
	var path = Bresenham.plot_line(start, corner)
	path.append_array(Bresenham.plot_line(corner, end))
	for point in path:
		_carve_tile(dungeon, point.x, point.y)

func _place_entities(dungeon: MapData, room: Rect2) -> void:
	var number_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	
	for _i in number_of_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2(x, y)
		
		var can_place = true
		for entity in dungeon.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity: Entity
			if _rng.randf() < 0.8:
				new_entity = Entity.new(new_entity_position, entity_types.orc)
			else:
				new_entity = Entity.new(new_entity_position, entity_types.troll)
			dungeon.entities.append(new_entity)
