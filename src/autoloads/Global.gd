extends Node

var playerBody: CharacterBody2D

var selectedCharacter: int = 0

var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D

var kukkSightZone: Area2D

var current_checkpoint : Checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		playerBody.global_position = current_checkpoint.global_position



# - Dungeon Generation -

var room = preload("res://scenes/procedural_dungeon_rooms.tscn")

var min_number_rooms = 8
var max_number_rooms = 16

var generation_chance = 20

var room_connect_up : bool
var room_connect_right : bool
var room_connect_down : bool
var room_connect_left : bool

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var rooms_to_generate = floor(randf_range(min_number_rooms, max_number_rooms))
	
	dungeon[Vector2(0,0)] = room.instantiate()
	rooms_to_generate -= 1
	
	room_connect_up = false
	room_connect_right = false
	room_connect_down = false
	room_connect_left = false
	
	while(rooms_to_generate > 0):
		for i in dungeon.keys():
			if (randf_range(0,100) < generation_chance) and rooms_to_generate > 0:
				var direction = randf_range(0,4)
				if (direction < 1):
					var new_room_pos = i + Vector2(1,0)
					if (!dungeon.has(new_room_pos)):
						dungeon[new_room_pos] = room.instantiate()
						room_connect_up = true
						rooms_to_generate -= 1
					if (dungeon.get(i).connected_rooms.get(Vector2(1,0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_pos), Vector2(1,0))
				elif (direction < 2):
					var new_room_pos = i + Vector2(-1,0)
					if (!dungeon.has(new_room_pos)):
						dungeon[new_room_pos] = room.instantiate()
						room_connect_right = true
						rooms_to_generate -= 1
					if (dungeon.get(i).connected_rooms.get(Vector2(-1,0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_pos), Vector2(-1,0))
				elif (direction < 3):
					var new_room_pos = i + Vector2(0,1)
					if (!dungeon.has(new_room_pos)):
						dungeon[new_room_pos] = room.instantiate()
						room_connect_down = true
						rooms_to_generate -= 1
					if (dungeon.get(i).connected_rooms.get(Vector2(0,1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_pos), Vector2(0,1))
				elif (direction < 4):
					var new_room_pos = i + Vector2(0,-1)
					if (!dungeon.has(new_room_pos)):
						dungeon[new_room_pos] = room.instantiate()
						room_connect_left = true
						rooms_to_generate -= 1
					if (dungeon.get(i).connected_rooms.get(Vector2(0,-1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_pos), Vector2(0,-1))
	while (!is_interesting(dungeon)):
		for i in dungeon.keys():
			dungeon.get(i).queue_free()
		dungeon = generate(room_seed * randf_range(-1,1) + randf_range(-1,1))
	return dungeon

func connect_rooms(room1, room2, dir):
	room1.connected_rooms[dir] = room2
	room2.connected_rooms[-dir] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1
	room1.number_of_connections += 1
	room2.number_of_connections += 1


func is_interesting(dungeon):
	var room_with_three = 0
	for i in dungeon.keys():
		if (dungeon.get(i).number_of_connections >= 3):
			room_with_three += 1
	return room_with_three >= 2


