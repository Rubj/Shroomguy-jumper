class_name SettingsMenu
extends Control

@onready var save_and_exit_button: Button = $MarginContainer/VBoxContainer/Save_And_Exit_Button as Button

signal exit_settings_menu


func _ready() -> void:
	save_and_exit_button.button_down.connect(on_exit_pressed)
	set_process(false)


func on_exit_pressed() -> void:
	Saver.saveSettings()
	exit_settings_menu.emit()
	set_process(false)
