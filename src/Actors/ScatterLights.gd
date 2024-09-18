extends Node2D

var lights_count: int = 20

func handle_lights():
	for n in lights_count:
		var rand_pos = Vector2(randf_range(2000, 14000), randf_range(-2000, -16000))
		var collision_obj = RayCast2D.new()
		collision_obj.set_transform(Transform2D(0, Vector2(2,2), 0, rand_pos));
		collision_obj.set_collide_with_bodies(true)
		collision_obj.set_collide_with_areas(true)
		add_child(collision_obj)
		if collision_obj.is_colliding():
			break
			print("collision happening")
		else:
			print("collision NOT happening")
			var light_instance = preload("res://scenes/point_light_2d.tscn").instantiate()
			light_instance.set_position(rand_pos)
			add_child(light_instance)

func _ready() -> void:
	await get_tree().create_timer(0.4).timeout
	handle_lights()
