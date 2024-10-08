extends Node2D

var dungeon = {}
var node_sprite = load("res://assets/textures/dungeon test/map_nodes1.png")
var branch_sprite = load("res://assets/textures/dungeon test/map_nodes3.png")

@onready var room_asset = $TileMap.tile_set.get_pattern(2)
@onready var path_asset = $TileMap.tile_set.get_pattern(3)
@onready var map_node = $MapNode

func _ready():
	dungeon = Global.generate(0)
	load_map()

func load_map():
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
		
	for i in dungeon.keys():
		var temp = Sprite2D.new()
		temp.texture = node_sprite
		map_node.add_child(temp)
		temp.z_index = 1
		temp.position = i * 10
		temp.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var c_rooms = dungeon.get(i).connected_rooms
		if(c_rooms.get(Vector2(1, 0)) != null):
			temp = Sprite2D.new()
			temp.texture = branch_sprite
			map_node.add_child(temp)
			temp.z_index = 0
			temp.position = i * 10 + Vector2(5, 0.5)
			temp.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		if(c_rooms.get(Vector2(0, 1)) != null):
			temp = Sprite2D.new()
			temp.texture = branch_sprite
			map_node.add_child(temp)
			temp.z_index = 0
			temp.rotation_degrees = 90
			temp.position = i * 10 + Vector2(-0.5, 5)
			temp.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _on_button_pressed() -> void:
	randomize()
	dungeon = Global.generate(randf_range(-1000, 1000))
	load_map()
