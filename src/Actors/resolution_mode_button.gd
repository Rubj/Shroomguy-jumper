extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton


func _ready() -> void:
	add_resolution_items()
	option_button.select(Saver.RES)
	option_button.item_selected.connect(on_resolution_selected)

func add_resolution_items() -> void:
	for resolution_size_text in Saver.RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)


func on_resolution_selected(index : int) -> void:
	Saver.RES = index
	Saver.setWindowValues()
	
