extends Camera2D
var zoom_value = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#does not work
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		zoom_value += 0.1;
		zoom = Vector2(zoom_value, zoom_value);
		print('appoi');
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		zoom_value -= 0.1;
		zoom = Vector2(zoom_value, zoom_value);
		print('0')
