extends Control


@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton


func _ready() -> void:
	add_window_mode_items()
	option_button.select(Saver.WMODE)
	option_button.item_selected.connect(on_window_mode_selected)

func add_window_mode_items() -> void:
	for window_mode in Saver.WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)

func on_window_mode_selected(index : int) -> void:
	Saver.WMODE = index
	Saver.setWindowValues
