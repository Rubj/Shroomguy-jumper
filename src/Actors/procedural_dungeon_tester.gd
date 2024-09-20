extends Node2D

var dungeon = {}
var node_sprite = load("res://assets/textures/dungeon test/map_nodes1.png")
var branch_sprite = load("res://assets/textures/dungeon test/map_nodes3.png")

@onready var Level = $TileMap
@onready var room_4_open = $TileMap.tile_set.get_pattern(6)
@onready var room_2_open_horizontal = $TileMap.tile_set.get_pattern(9)
@onready var room_2_open_vertival = $TileMap.tile_set.get_pattern(10)
@onready var room_1_open_up = $TileMap.tile_set.get_pattern(11)
@onready var room_1_open_left = $TileMap.tile_set.get_pattern(12)
@onready var room_1_open_down = $TileMap.tile_set.get_pattern(13)
@onready var room_1_open_right = $TileMap.tile_set.get_pattern(14)
@onready var room_2_open_left_up = $TileMap.tile_set.get_pattern(15)
@onready var room_2_open_up_right = $TileMap.tile_set.get_pattern(16)
@onready var room_2_open_right_down = $TileMap.tile_set.get_pattern(17)
@onready var room_2_open_down_left = $TileMap.tile_set.get_pattern(18)
@onready var room_3_open_left = $TileMap.tile_set.get_pattern(19)
@onready var room_3_open_up = $TileMap.tile_set.get_pattern(20)
@onready var room_3_open_right = $TileMap.tile_set.get_pattern(21)
@onready var room_3_open_down = $TileMap.tile_set.get_pattern(22)
@onready var path_horizontal = $TileMap.tile_set.get_pattern(7)
@onready var path_vertical = $TileMap.tile_set.get_pattern(8)

func _ready():
	dungeon = Global.generate(0)
	load_map()

func load_map():
	Level.clear()
	
	for i in dungeon.keys():
		if Global.room_connect_up == true && Global.room_connect_right == true && Global.room_connect_down == true && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_4_open)
		elif  Global.room_connect_up == false && Global.room_connect_right == true && Global.room_connect_down == false && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_2_open_horizontal)
		elif Global.room_connect_up == true && Global.room_connect_right == false && Global.room_connect_down == true && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_2_open_vertival)
		elif Global.room_connect_up == true && Global.room_connect_right == false && Global.room_connect_down == false && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_1_open_up)
		elif Global.room_connect_up == false && Global.room_connect_right == false && Global.room_connect_down == false && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_1_open_left)
		elif Global.room_connect_up == false && Global.room_connect_right == false && Global.room_connect_down == true && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_1_open_down)
		elif  Global.room_connect_up == false && Global.room_connect_right == true && Global.room_connect_down == false && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_1_open_right)
		elif Global.room_connect_up == true && Global.room_connect_right == false && Global.room_connect_down == false && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_2_open_left_up)
		elif Global.room_connect_up == true && Global.room_connect_right == true && Global.room_connect_down == false && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_2_open_up_right)
		elif Global.room_connect_up == false && Global.room_connect_right == true && Global.room_connect_down == true && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_2_open_right_down)
		elif Global.room_connect_up == false && Global.room_connect_right == false && Global.room_connect_down == true && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_2_open_down_left)
		elif Global.room_connect_up == true && Global.room_connect_right == false && Global.room_connect_down == true && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_3_open_left)
		elif Global.room_connect_up == true && Global.room_connect_right == true && Global.room_connect_down == false && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_3_open_up)
		elif Global.room_connect_up == true && Global.room_connect_right == true && Global.room_connect_down == true && Global.room_connect_left == false:
			Level.set_pattern(0, i * 40, room_3_open_right)
		elif Global.room_connect_up == false && Global.room_connect_right == true && Global.room_connect_down == true && Global.room_connect_left == true:
			Level.set_pattern(0, i * 40, room_3_open_down)
			var c_rooms = dungeon.get(i).connected_rooms
			if(c_rooms.get(Vector2(1, 0)) != null):
				Level.set_pattern(0, i * 40 + Vector2(32, 14), path_horizontal)
			if(c_rooms.get(Vector2(0, 1)) != null):
				Level.set_pattern(0, i * 40 + Vector2(14, 32), path_vertical)

func _on_button_pressed() -> void:
	randomize()
	dungeon = Global.generate(randf_range(-1000, 1000))
	load_map()
