extends Line2D

@export var lenght = 15
@onready var parent = get_parent()

func _ready() -> void:
	top_level = true
	clear_points()
	
func _process(delta: float) -> void:
	add_point(parent.global_position)
	
	if points.size() > lenght:
		remove_point(0)
