extends CharacterBody2D

@export var speed_max = 125
@export var acceleration = 1
@export var run_speed_max = 350
@export var run_acceleration = 3
@export var gravity = 17
@export var jump_force = 170
@export var cayote_time: int = 15
@export var jump_buffer_time: int = 10
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0, 1.0) var run_friction = 0.01

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var running = false

var cayote_counter: int = 0
var jump_counter: int = 0
var jump_buffer_counter: int = 0


func _ready():
	Global.playerBody = self

func _physics_process(delta):
	if is_on_floor():
		cayote_counter = cayote_time
		jump_counter = 0
	
	if !is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
		
		if jump_buffer_counter > 0 and jump_counter < 0: # <-- set to 1 to double jump
			cayote_counter = 1
			jump_counter += 1
		
		velocity.y += gravity
		if velocity.y > 1200:
			velocity.y = 1200
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0

	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if horizontal_direction != 0:
		velocity.x = lerp(velocity.x, speed_max * horizontal_direction, acceleration)
		velocity.x = clamp(velocity.x, -speed_max, speed_max)
		sprite.flip_h = (horizontal_direction == 1)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	if Input.is_action_pressed("hold run") and velocity.x != 0:
		running = true
		if running and horizontal_direction != 0:
			velocity.x = lerp(velocity.x, run_speed_max * horizontal_direction, run_acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, run_friction)
			
		velocity.x = clamp(velocity.x, -run_speed_max, run_speed_max)
		
	if ! Input.is_action_pressed("hold run"):
		running = false
	
	move_and_slide()
	update_animations(horizontal_direction)


func update_animations(horizontal_direction):
		if is_on_floor():
			if horizontal_direction == 0:
				ap.play("idle")
			elif running:
				ap.play("run")
			else:
				ap.play("walk")
		elif velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")

