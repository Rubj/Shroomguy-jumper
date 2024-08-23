extends Node2D

var player_plot_scene = load("res://scenes/player_plot.tscn").instantiate()
var player_clay_scene = load("res://scenes/player_clay.tscn").instantiate()
var player_kukk_scene = load("res://scenes/player_kukk.tscn").instantiate()

func _on_ready() -> void:
	if Global.selectedCharacter == 0:
		spawn_plot()
	elif Global.selectedCharacter == 1:
		spawn_clay()
	else:
		spawn_kukk()

func spawn_plot() -> void:
	player_plot_scene.set_name("player_plot") # ma ei tea mida set_name teeb
	add_child(player_plot_scene)

func spawn_clay() -> void:
	player_clay_scene.set_name("player_clay")
	add_child(player_clay_scene)

func spawn_kukk() -> void:
	player_kukk_scene.set_name("player_kukk")
	add_child(player_kukk_scene)
