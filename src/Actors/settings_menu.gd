class_name SettingsMenu
extends Control

@onready var back_button: Button = $MarginContainer/VBoxContainer/Back_Button as Button

signal exit_settings_menu


func _ready() -> void:
	back_button.button_down.connect(on_exit_pressed)
	set_process(false)


func on_exit_pressed() -> void:
	Saver.saveSettings()
	exit_settings_menu.emit()
	set_process(false)


