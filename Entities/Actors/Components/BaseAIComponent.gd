class_name BaseAIComponent
extends Component

signal react_action(type, offset)

var actor_offset: Vector2
var target_offset: Vector2
var pathfinder: AStar2D
var path: Array = []

func get_awareness(from: Vector2, to: Vector2, finder: AStar2D) -> void:
	actor_offset = from
	target_offset = to
	pathfinder = finder
	path = []

func perform() -> void:
	pass

func move_updated() -> void:
	if path.size() > 0:
		path.pop_front()
