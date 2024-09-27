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

const SCREEN_DICTIONARY : Dictionary = {
	"Screen 0" : int(0),
	"Screen 1" : int(1)
}

var WMODE: int = 1
var RES: int = 0
var SCREEN: int = DisplayServer.window_get_current_screen()
var POS: Vector2 = DisplayServer.window_get_position()

func _ready() -> void:
	#get_node(".").exit_settings_menu.connect(saveSettings)
	if (FileAccess.file_exists('cool_save.json')):
		var saveStr = FileAccess.open('cool_save.json', FileAccess.READ).get_as_text()
		var json = JSON.new()
		var error = json.parse(saveStr)
		if error == OK:
			var dict: Dictionary = json.data
			WMODE = dict["WMODE"] if dict.has("WMODE") else WMODE
			RES = dict["RES"] if dict.has("RES") else RES
			SCREEN = dict["SCREEN"] if dict.has("SCREEN") else SCREEN
			POS = str_to_var("Vector2"+dict["POS"]) if dict.has("POS") else POS
			print('load! ', dict)
	setWindowValues()

func setWindowValues() -> void:
	DisplayServer.window_set_position(POS) #TODO why pos always same
	#TODO set SCREEN
	
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
	
	DisplayServer.window_set_current_screen(SCREEN_DICTIONARY[SCREEN_DICTIONARY.keys()[SCREEN]])

func saveSettings() -> void: #TODO call this on exit also
	var dict = {
		"RES": RES,
		"WMODE": WMODE,
		"SCREEN": SCREEN,
		"POS": POS
	}
	print('save! ', dict)
	var saveFile = FileAccess.open('cool_save.json', FileAccess.WRITE)
	saveFile.store_string(JSON.stringify(dict))

