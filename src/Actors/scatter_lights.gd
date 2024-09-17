@tool
extends Node2D

var light_instance = preload("res://scenes/point_light_2d.tscn").instantiate()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		light_instance.set_position(Vector2(randf_range(-200,200), randf_range(-100, 200)))
		add_child(light_instance)
