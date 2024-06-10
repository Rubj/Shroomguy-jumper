extends Node

var player_plot_scene = load("res://scenes/player_plot.tscn").instantiate()
var player_clay_scene = load("res://scenes/player_clay.tscn").instantiate()
#var world_scene = preload("res://scenes/world.tscn").instantiate()

var playerBody: CharacterBody2D

#var playerController = world_scene.get_child(0)

var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D

var kukkSightZone: Area2D

func spawn_plot() -> void:
	player_plot_scene.set_name("player_plot") # ma ei tea mida set_name teeb
	add_child(player_plot_scene)

func spawn_clay() -> void:
	player_clay_scene.set_name("player_clay")
	add_child(player_clay_scene)
