extends CharacterBody2D
class_name Player

@export var speed_max = 125
@export var acceleration = 1
@export var run_speed_max = 350
@export var run_acceleration = 3
@export var gravity = 17
@export var jump_force = 170
@export var cayote_time: int = 15
@export var jump_buffer_time: int = 10
@export var dash_speed = 500
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0, 1.0) var run_friction = 0.01

@onready var ap = $AnimationPlayer
@onready var aps = $DealDamageZone/AnimationPlayerSmear
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2
@onready var deal_damage_zone = $DealDamageZone
@onready var smears_sprite = $DealDamageZone/Sprite2D

var dashing = false
var can_dash = true

var attack_type: String
var attacking: bool

var running = false

var is_crouching = false
var stuck_under_object = false

var cayote_counter: int = 0
var jump_counter: int = 0
var jump_buffer_counter: int = 0

var Time_Actual_Double : float = 0
var Time_Double : float = 0.05
var Time_Life_Double : float = 0.2

var standing_cshape = preload("res://resources/shroomguy_standing_cshape.tres")
var crouching_cshape = preload("res://resources/shroomguy_crouching_cshape.tres")


func _ready():
	attacking = false
	Global.playerBody = self
	smears_sprite.visible = false

func _physics_process(delta):
	Global.playerDamageZone = deal_damage_zone
	
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
	
	if Input.is_action_just_pressed("jump") and !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding():
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
		deal_damage_zone.scale.x = -horizontal_direction
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	if Input.is_action_pressed("hold run") and velocity.x != 0:
		running = true
		if Time_Actual_Double >= Time_Double:
			Time_Actual_Double = 0
			clear_dash_double()
			
		Time_Actual_Double += delta
		
		if running and horizontal_direction != 0:
			velocity.x = lerp(velocity.x, run_speed_max * horizontal_direction, run_acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, run_friction)
			
		velocity.x = clamp(velocity.x, -run_speed_max, run_speed_max)
		
	if ! Input.is_action_pressed("hold run"):
		running = false
		
		Time_Actual_Double != delta
	
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
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()
	var mouse_direction = get_local_mouse_position().normalized()
	var dash_direction = Vector2(mouse_direction.x * 1.5, mouse_direction.y * 0.5)
	if dashing:
		velocity = dash_speed * dash_direction
		
	if !attacking and !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding():
		if Input.is_action_just_pressed("attack_single") or Input.is_action_just_pressed("attack_double"):
			attacking = true
			if Input.is_action_just_pressed("attack_single") and is_on_floor():
				attack_type = "single"
			elif Input.is_action_just_pressed("attack_double") and is_on_floor():
				attack_type = "double"
			elif Input.is_action_just_pressed("attack_single") or Input.is_action_just_pressed("attack_double") and !is_on_floor():
				attack_type = "air"
			set_damage(attack_type)
			handle_attack_animation(attack_type)

	move_and_slide()
	update_animations(horizontal_direction)
	
	if position.y >= 3500:
		die()


func update_animations(horizontal_direction):
	if dashing:
		ap.play("dash_roll")
	else:
		if is_on_floor() and !attacking:
			if horizontal_direction == 0:
				if is_crouching:
					ap.play("crouch_idle")
				else:
					ap.play("idle")
			else:
				if is_crouching:
					ap.play("crouch_walk")
				else:
					if running:
						ap.play("run")
					else:
						ap.play("walk")
		elif velocity.y < 0 and !attacking:
			ap.play("jump")
		elif velocity.y > 0 and !attacking:
			ap.play("fall")
			



func above_head_is_empty() -> bool:
	var result = !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding()
	return result

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

func handle_attack_animation(attack_type):
	if attacking:
		var animation = str(attack_type, "_attack")
		ap.play(animation)
		print(animation)
		toggle_damage_collisions(attack_type)
		if attack_type == "air":
			aps.play("air_01_attack")
		if attack_type == "single":
			aps.play("single_01_attack")
		if attack_type == "double":
			aps.play("double_01_attack")

func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	if attack_type == "air":
		wait_time = 0.4
		damage_zone_collision.position.x = 0
		damage_zone_collision.position.y = -43
		damage_zone_collision.scale.x = 2.0
		damage_zone_collision.scale.y = 2.0
	elif attack_type == "single":
		wait_time = 0.5
		damage_zone_collision.position.x = -60
		damage_zone_collision.position.y = -57
		damage_zone_collision.scale.x = 1.2
		damage_zone_collision.scale.y = 1.2
	elif attack_type == "double":
		wait_time = 0.8
		damage_zone_collision.position.x = -60
		damage_zone_collision.position.y = -57
		damage_zone_collision.scale.x = 1.0
		damage_zone_collision.scale.y = 1.0
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true
	
func _on_animation_player_animation_finished(anim_name: StringName):
	attacking = false

func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "single":
		current_damage_to_deal = 8
	elif attack_type == "double":
		current_damage_to_deal = 16
	elif attack_type == "air":
		current_damage_to_deal = 20
	Global.playerDamageAmount = current_damage_to_deal

func die():
	Global.respawn_player()

func clear_dash_double():
	var dash_double = $Sprite2D.duplicate(true)
	dash_double.material = $Sprite2D.material.duplicate(true)
	dash_double.material.set_shader_parameter("opacity", 0.3)
	dash_double.material.set_shader_parameter("r", 0.0)
	dash_double.material.set_shader_parameter("g", 0.0)
	dash_double.material.set_shader_parameter("b", 0.8)
	dash_double.material.set_shader_parameter("mix_color", 0.7)
	dash_double.position.y += position.y
	
	if $Sprite2D.scale.x == -1:
		dash_double.position.x = position.x - dash_double.position.x
	else:
		dash_double.position.x += position.x
	dash_double.z_index -= 1
	get_parent().add_child(dash_double)
	await get_tree().create_timer(Time_Life_Double).timeout
	dash_double.queue_free()

