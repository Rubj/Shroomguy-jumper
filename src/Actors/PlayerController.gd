extends Node2D

#var scene = load("res://scenes/player_plot.tscn")
#var scene_instance = scene.instantiate()

func _on_ready() -> void:
	Global.spawn_plot()
