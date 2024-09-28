class_name CharacterSelection
extends Control

#var main = preload("res://scenes/world.tscn")

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var plot_ap: AnimationPlayer = $MarginContainer/VBoxContainer/Plot/AnimationPlayer
@onready var plot_as: Sprite2D = $MarginContainer/VBoxContainer/Plot/PlotAnimationSprite
@onready var scene_transition_ap: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer

func _ready() -> void:
	plot_as.self_modulate = Color(1.0, 1.0, 1.0, 0.8)

func _on_plot_mouse_entered() -> void:
	plot_as.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_plot_mouse_exited() -> void:
	plot_as.self_modulate = Color(1.0, 1.0, 1.0, 0.8)

# For future me - don't copy paste buttons, it will not work

func _on_plot_pressed() -> void:
	plot_ap.play("play_on_click")
	await get_tree().create_timer(2.2).timeout
	scene_transition_ap.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	Global.selectedCharacter = 0
	go_to_level()
	


func _on_clay_pressed() -> void:
	ap.play("fade_to_black")
	await get_tree().create_timer(0.5).timeout
	Global.selectedCharacter = 1
	go_to_level()

func _on_kukk_pressed() -> void:
	ap.play("fade_to_black")
	await get_tree().create_timer(0.5).timeout
	Global.selectedCharacter = 2
	go_to_level()


func go_to_level() -> void:
	Global.gameStarted = true
	scene_transition_ap.get_parent().get_node("ColorRect").color.a = 255
	Global.next_scene = "res://scenes/world.tscn"
	get_tree().change_scene_to_packed(Global.loading_screen)
