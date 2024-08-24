extends Control

#var main = preload("res://scenes/world.tscn")

func _ready() -> void:
	get_viewport().size = DisplayServer.screen_get_size()
	
	$MarginContainer/VBoxContainer/Plot/Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 0.8)

func _on_plot_mouse_entered() -> void:
	$MarginContainer/VBoxContainer/Plot/Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_plot_mouse_exited() -> void:
	$MarginContainer/VBoxContainer/Plot/Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 0.8)

# For future me - don't copy paste buttons, it will not work

func _on_plot_pressed() -> void:
	$MarginContainer/VBoxContainer/Plot/AnimationPlayer.play("play_on_click")
	await get_tree().create_timer(2.2).timeout
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	Global.selectedCharacter = 0


func _on_clay_pressed() -> void:
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	Global.selectedCharacter = 1


func _on_kukk_pressed() -> void:
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	Global.selectedCharacter = 2
