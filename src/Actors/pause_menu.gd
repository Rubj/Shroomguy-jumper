extends Control

@onready var main = $".."

func _on_resume_pressed() -> void:
	main.pausedMenu()

func _on_settings_pressed() -> void:
	pass 

func _on_title_screen_pressed() -> void:
	main.pausedMenu()
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
