class_name FighterComponent
extends Component

var max_hp: int
var hp: int
var defense: int
var power: int

func set_hp(value):
	hp = int(clamp(value, 0, max_hp))

func _init(definition: FighterComponentDefinition) -> void:
	max_hp = definition.max_hp
	hp = definition.max_hp
	defense = definition.defense
	power = definition.power
