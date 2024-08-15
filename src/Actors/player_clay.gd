extends CharacterBody2D

@export var speed_max = 125
@export var acceleration = 1
@export var run_speed_max = 200
@export var run_acceleration = 3
@export var gravity = 17
@export var jump_force = 270
@export var cayote_time: int = 15
@export var jump_buffer_time: int = 10
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0, 1.0) var run_friction: float = 0.01

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var cayote_counter: int = 0
var jump_counter: int = 0
var jump_buffer_counter: int = 0

var is_ladder: bool                            = false
var assemble_ladder_animation_playing: bool    = false
var disassemble_ladder_animation_playing: bool = false


func _ready():
	Global.playerBody = self

func _physics_process(delta):
	if is_on_floor():
		cayote_counter = cayote_time
		jump_counter = 0
	else:
		if cayote_counter > 0:
			cayote_counter -= 1

		if jump_buffer_counter > 0 and jump_counter < 1: # <-- set to 1 to double jump
			cayote_counter = 1
			jump_counter += 1

		velocity.y += gravity
		if velocity.y > 1200:
			velocity.y = 1200




	var horizontal_direction: float = Input.get_axis("move_left", "move_right");
	if is_ladder:
		velocity.x = 0
	else:
		if Input.is_action_just_pressed("jump"):
			jump_buffer_counter = jump_buffer_time

		if jump_buffer_counter > 0:
			jump_buffer_counter -= 1

		if jump_buffer_counter > 0 and cayote_counter > 0:
			velocity.y = -jump_force
			jump_buffer_counter = 0
			cayote_counter = 0
		if horizontal_direction != 0 and !assemble_ladder_animation_playing and !disassemble_ladder_animation_playing:
			velocity.x = lerp(velocity.x, speed_max * horizontal_direction, acceleration)
			velocity.x = clamp(velocity.x, -speed_max, speed_max)
			sprite.flip_h = (horizontal_direction == 1)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)

	if Input.is_action_just_pressed("ability01") and is_on_floor():
		if is_ladder:
			print('hakka mitte redeliks')
			disassemble_ladder_animation_playing = true
			print(ap.get_assigned_animation())
			await get_tree().create_timer(6.1).timeout
			print(ap.get_assigned_animation())
			disassemble_ladder_animation_playing = false
			print('set is ladder false')
			setIsLadder(false)
		else:
			assemble_ladder_animation_playing = true
			await get_tree().create_timer(6.1).timeout
			assemble_ladder_animation_playing = false
			setIsLadder(true)



	move_and_slide()
	update_animations(horizontal_direction)


func update_animations(horizontal_direction):
	#print('assemble_ladder_animation_playing:' + str(assemble_ladder_animation_playing) + ' disassemble_ladder_animation_playing:' + str(disassemble_ladder_animation_playing))
	if assemble_ladder_animation_playing:
		ap.play("ladder")
	elif disassemble_ladder_animation_playing:
		ap.play("ladder_backwards") #todo
	else:
		if is_ladder:
			ap.play("ladder_idle")
		else:
			if is_on_floor():
				if horizontal_direction == 0:
					ap.play("idle")
				else:
					ap.play("walk")
			else:
				pass
				#ap.play("fall") todo


func setIsLadder(v: bool):
	if is_ladder != v:
		is_ladder = v
