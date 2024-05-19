extends CharacterBody2D

@export var speed = 200
@export var gravity = 40
@export var jump_force = 150
@export var dash_speed = 500

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2

var dashing = false
var can_dash = true

var is_crouching = false
var stuck_under_object = false

var standing_cshape = preload("res://resources/shroomguy_standing_cshape.tres")
var crouching_cshape = preload("res://resources/shroomguy_crouching_cshape.tres")

func _physics_process(delta):
		
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1500:
			velocity.y = 1500
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == 1)
	
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif  Input.is_action_just_released("crouch"):
		if above_head_is_empty():
			stand()
		else:
			if stuck_under_object != true:
				stuck_under_object = true
	
	if stuck_under_object && above_head_is_empty():
		if !Input.is_action_pressed("crouch"):
			stand()
			stuck_under_object = false
	
#	-- OLD DASH --
#	if Input.is_action_just_pressed("dash") and can_dash:
#		dashing = true
#		can_dash = false
#		$dash_timer.start()
#		$dash_again_timer.start()
#		var mouse_direction = get_local_mouse_position().normalized()
#		velocity = Vector2(dash_speed * mouse_direction.x, dash_speed * mouse_direction.y)
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()
	var mouse_direction = get_local_mouse_position().normalized()
	var dash_direction = Vector2(mouse_direction.x * 1.5, mouse_direction.y * 0.5)
	if dashing:
		velocity = dash_speed * dash_direction
	
	move_and_slide()
	
	update_animations(horizontal_direction)

func above_head_is_empty() -> bool:
	var result = !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding()
	return result

func update_animations(horizontal_direction):
	print(is_on_floor())
	if dashing:
		ap.play("dash_roll")
	else:
		if is_on_floor():
			if horizontal_direction == 0:
				if is_crouching:
					ap.play("crouch_idle")
				else:
					ap.play("idle")
			else:
				if is_crouching:
					ap.play("crouch_walk")
				else:
					ap.play("walk")
		elif velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")

func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = -26

func stand():
	if is_crouching == false:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = -36

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
