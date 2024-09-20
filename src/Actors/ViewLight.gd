extends PointLight2D

var smoothed_mouse_pos: Vector2

func _process(delta: float) -> void:
	smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.5)
	rotate(1.5708+get_angle_to(smoothed_mouse_pos))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ability01") and enabled == false:
		enabled = true
	elif Input.is_action_just_pressed("ability01") and enabled == true:
		enabled = false
