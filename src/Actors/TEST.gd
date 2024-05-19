extends CharacterBody2D

# Speed of the player
var speed = 200
# Dash speed multiplier
var dash_multiplier = 5
# Dash cooldown
var dash_cooldown = 1.5
var can_dash = true


func _process(delta):
	# Get the mouse position
	var mouse_position = get_global_mouse_position()
	
	# Calculate the direction vector from the player to the mouse position
	var direction = (mouse_position - global_position).normalized()

	# Move the player towards the mouse position
	move_and_slide()

	# Handle dash cooldown
	if not can_dash:
		dash_cooldown -= delta
		if dash_cooldown <= 0:
			can_dash = true
			dash_cooldown = 1.5

func _input(event):
	if Input.is_action_just_pressed("dash"):
		# Get the mouse position
		var mouse_position = get_global_mouse_position()
		
		# Calculate the direction vector from the player to the mouse position
		var direction = (mouse_position - global_position).normalized()

		# Perform dash
		dash(direction)

func dash(direction):
	# Apply a dash impulse
	var dash_strength = 1000
	var dash_vector = direction * dash_strength * dash_multiplier
	
	# Disable dashing temporarily
	can_dash = false
