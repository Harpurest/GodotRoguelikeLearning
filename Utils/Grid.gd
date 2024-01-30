class_name Grid
extends Reference

const tile_size = Vector2(16, 16)
const map_width = 80
const map_height = 45

static  func grid_to_world(grid_pos: Vector2) -> Vector2:
	var world_pos: Vector2 = grid_pos * tile_size
	return world_pos

static func world_to_grid(world_pos: Vector2) -> Vector2:
	var grid_x = int(world_pos.x / tile_size.x)
	var grid_y = int(world_pos.y / tile_size.y)
	var grid_pos: Vector2 = Vector2(grid_x, grid_y)
	return grid_pos

static func calculate_point_index(point) -> int:
	return point.x + map_width * point.y
