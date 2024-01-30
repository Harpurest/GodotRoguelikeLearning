class_name MapData
extends Reference

const tile_types = {
	"floor": preload("res://Assets/Definitions/Tiles/tile_definition_floor.tres"),
	"wall": preload("res://Assets/Definitions/Tiles/tile_definition_wall.tres"),
}

const entity_pathfinding_weight: = 10.0

var width: int
var height: int
var tiles: Array
var entities: Array
var pathfinder: AStar2D
var obstacles: = []

func _init(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	entities = []
	_setup_tiles()
	
func _setup_tiles() -> void:
	tiles = []
	for y in height:
		for x in width:
			var tile_position := Vector2(x, y)
			var tile := Tile.new(tile_position, tile_types.wall)
			tiles.append(tile)

func get_tile(grid_position: Vector2) -> Tile:
	var tile_index: int = grid_to_index(grid_position)
	if tile_index == -1:
		return null
	return tiles[tile_index]

func grid_to_index(grid_position: Vector2) -> float:
	if not is_in_bounds(grid_position):
		return -1.0
	return grid_position.y * width + grid_position.x

func is_in_bounds(coordinate: Vector2) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)

func get_tile_xy(x: int, y: int) -> Tile:
	var grid_position := Vector2(x, y)
	return get_tile(grid_position)

func get_blocking_entity_at_location(grid_position: Vector2) -> Entity:
	for entity in entities:
		if entity.is_blocking_movement() and entity.grid_position == grid_position:
			return entity
	return null

func setup_pathfinding() -> void:
	pathfinder = AStar2D.new()
	obstacles = get_obstacles()
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	for entity in entities:
		if entity.is_blocking_movement():
			register_blocking_entity((entity as Entity).grid_position)

func get_obstacles() -> Array:
	for y in height:
		for x in width:
			var grid_position := Vector2(x, y)
			var tile: Tile = get_tile(grid_position)
			if not tile.is_walkable():
				obstacles.push_back(calculate_point_index(grid_position))
	return obstacles

func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(height):
		for x in range(width):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			var point_index = calculate_point_index(point)
			pathfinder.add_point(point_index, Vector2(point.x, point.y), 1.0)
	return points_array

func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if is_outside_map_bounds(point_relative):
				continue
			if not pathfinder.has_point(point_relative_index):
				continue

			pathfinder.connect_points(point_index, point_relative_index, false)

func astar_connect_walkable_cells_diagonal(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not pathfinder.has_point(point_relative_index):
					continue
				pathfinder.connect_points(point_index, point_relative_index, false)

func _recalculate_path(path_start_position, path_end_position):
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	var _point_path = pathfinder.get_point_path(start_point_index, end_point_index)
	return _point_path

func get_point_path(path_start_position, path_end_position):
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	var _point_path = pathfinder.get_point_path(start_point_index, end_point_index)
	return _point_path

func register_blocking_entity(position: Vector2) -> void:
	pathfinder.set_point_weight_scale(\
		calculate_point_index(position),\
		entity_pathfinding_weight)

func unregister_blocking_entity(position: Vector2) -> void:
	pathfinder.set_point_weight_scale(\
		calculate_point_index(position),\
		1.0)

func calculate_point_index(point):
	return point.x + width * point.y

func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= width or point.y >= height
