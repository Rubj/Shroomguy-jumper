extends Node

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Windowed",
	"Borderless Windowed",
	"Borderless Full-Screen"
]

const RESOLUTION_DICTIONARY : Dictionary = {
	"1920 x 1080" : Vector2i(1920, 1080),
	"1280 x 720" : Vector2i(1280, 720),
	"1152 x 648" : Vector2i(1152, 648)
}

var WMODE: int = 1
var RES: int = 0

func _ready() -> void:
	#get_node(".").exit_settings_menu.connect(saveSettings)
	if (FileAccess.file_exists('cool_save.json')):
		var saveStr = FileAccess.open('cool_save.json', FileAccess.READ).get_as_text()
		var json = JSON.new()
		var error = json.parse(saveStr)
		if error == OK:
			var dict = json.data
			WMODE = dict["WMODE"]
			RES = dict["RES"]
			print('load! ', dict, ' wmode: ', WMODE,' res: ', RES)
	setWindowValues()

func setWindowValues() -> void:
	match WMODE:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY[RESOLUTION_DICTIONARY.keys()[RES]])

func saveSettings() -> void:
	var dict = {
		"RES": RES,
		"WMODE": WMODE
	}
	print('save! ', dict, ' wmode: ', WMODE,' res: ', RES)
	var saveFile = FileAccess.open('cool_save.json', FileAccess.WRITE)
	saveFile.store_string(JSON.stringify(dict))

