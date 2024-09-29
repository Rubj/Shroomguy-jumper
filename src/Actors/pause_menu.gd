class_name PauseMenu
extends Control

@onready var main = $".."

@onready var settings_menu: SettingsMenu = $Settings_Menu as SettingsMenu
@onready var character_selection: Control = $Character_selection as CharacterSelection

@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer

func _ready() -> void:
	handle_connecting_signals()

func _on_resume_pressed() -> void:
	main.pausedMenu()  # ma ei tea mida see pausedMenu() teeb

func _on_settings_pressed() -> void:
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true

func _on_title_screen_pressed() -> void:
	main.pausedMenu()
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")

func _on_quit_pressed() -> void:
	Saver.saveSettings()
	get_tree().quit()

func _on_respawn_pressed() -> void:
	main.pausedMenu()
	Global.respawn_player()

func _on_exit_settings_menu() -> void:
	margin_container.visible = true
	settings_menu.visible = false

func handle_connecting_signals() -> void:
	settings_menu.exit_settings_menu.connect(_on_exit_settings_menu)


