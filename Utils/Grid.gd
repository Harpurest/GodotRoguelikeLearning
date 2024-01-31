extends Node

var tile_size = Vector2(16, 16)
var map_width = 80
var map_height = 45

func grid_to_world(grid_pos: Vector2) -> Vector2:
	var world_pos: Vector2 = grid_pos * tile_size
	return world_pos

func world_to_grid(world_pos: Vector2) -> Vector2:
	var grid_x = int(world_pos.x / tile_size.x)
	var grid_y = int(world_pos.y / tile_size.y)
	var grid_pos: Vector2 = Vector2(grid_x, grid_y)
	return grid_pos

func calculate_point_index(point) -> int:
	return point.x + map_width * point.y

func calculate_point_from_index(index) -> Vector2:
	var x = index % map_width;
	var y = int((index - x) / map_width)
	return Vector2(x, y)
