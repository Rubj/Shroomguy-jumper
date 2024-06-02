extends Control


func _ready() -> void:
	$MarginContainer/VBoxContainer/Play/Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 0.8)

func _on_play_mouse_entered() -> void:
	$MarginContainer/VBoxContainer/Play/Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_play_mouse_exited() -> void:
	$MarginContainer/VBoxContainer/Play/Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 0.8)

func _on_play_pressed() -> void:
	$MarginContainer/VBoxContainer/Play/AnimationPlayer.play("play_on_click")
	await get_tree().create_timer(2.2).timeout
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
