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

var SCREEN_DICTIONARY: Dictionary = {} #const after values filled in ready

var WMODE: int = 1
var RES: int = 0
var SCREEN: int = DisplayServer.window_get_current_screen()
var POS: Vector2 = DisplayServer.window_get_position()

func _ready() -> void:
	for i in DisplayServer.get_screen_count():
		SCREEN_DICTIONARY["Screen "+str(i)] = i
	
	#get_node(".").exit_settings_menu.connect(saveSettings)
	print('init screen ', DisplayServer.window_get_current_screen())
	print('init pos ', DisplayServer.window_get_position())
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
	#TODO check if position in window bounds
	DisplayServer.window_set_position(POS)

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
	
	if (SCREEN <= DisplayServer.get_screen_count() - 1):
		DisplayServer.window_set_current_screen(SCREEN)
	else:
		#TODO SAY THAT YOU NEED TO PLUG IN SCREEN TO KEEP THAT IN MEMORY, OTHERWISE get_screen_count() - 1 AND INITIAL POS
		SCREEN = DisplayServer.get_screen_count() - 1
		POS = Vector2(0, 35)

func saveSettings() -> void: #TODO call this on exit also
	POS = DisplayServer.window_get_position()
	SCREEN = DisplayServer.window_get_current_screen()
	var dict = {
		"RES": RES,
		"WMODE": WMODE,
		"SCREEN": SCREEN,
		"POS": POS
	}
	print('save! ', dict)
	var saveFile = FileAccess.open('cool_save.json', FileAccess.WRITE)
	saveFile.store_string(JSON.stringify(dict))
