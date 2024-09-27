extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton


func _ready() -> void:
	add_screen_items()
	option_button.select(Saver.SCREEN)
	option_button.item_selected.connect(on_screen_selected)

func add_screen_items() -> void:
	for screen_change_text in Saver.SCREEN_DICTIONARY:
		option_button.add_item(screen_change_text)


func on_screen_selected(index : int) -> void:
	Saver.SCREEN = index
	Saver.setWindowValues()
	
