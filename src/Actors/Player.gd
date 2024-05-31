extends CharacterBody2D

@export var speed = 100
@export var run_speed = 300
@export var gravity = 40
@export var jump_force = 150
@export var dash_speed = 500

@onready var ap = $AnimationPlayer
@onready var aps = $DealDamageZone/AnimationPlayerSmear
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2
@onready var deal_damage_zone = $DealDamageZone
@onready var smear_sprite_single = $DealDamageZone/Sprite2DSingle
@onready var smear_sprite_air = $DealDamageZone/Sprite2DAir

var dashing = false
var can_dash = true

var attack_type: String
var smear_type: String
var attacking: bool

var running = false

var is_crouching = false
var stuck_under_object = false

var standing_cshape = preload("res://resources/shroomguy_standing_cshape.tres")
var crouching_cshape = preload("res://resources/shroomguy_crouching_cshape.tres")

func _ready():
	attacking = false
	Global.playerBody = self
	smear_sprite_single.visible = false
	smear_sprite_air.visible = false

func _physics_process(delta):
	Global.playerDamageZone = deal_damage_zone
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1500:
			velocity.y = 1500
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding():
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == 1)
		deal_damage_zone.scale.x = -horizontal_direction
		
	if Input.is_action_pressed("hold run") and velocity.x != 0:
		running = true
		velocity.x = run_speed * horizontal_direction
	if !Input.is_action_pressed("hold run"):
		running = false
	
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
				smear_type = "single_01"
			elif Input.is_action_just_pressed("attack_double") and is_on_floor():
				attack_type = "double"
			elif Input.is_action_just_pressed("attack_single") or Input.is_action_just_pressed("attack_double") and !is_on_floor():
				attack_type = "air"
				smear_type = "air_01"
			set_damage(attack_type)
			handle_attack_animation(attack_type, smear_type)

	move_and_slide()
	update_animations(horizontal_direction)


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

func handle_attack_animation(attack_type, smear_type):
	if attacking:
		var animation = str(attack_type, "_attack")
		var animation_smear = str(smear_type, "_attack")
		ap.play(animation)
		smear_sprite_single.visible = true
		smear_sprite_air.visible = true
		aps.play(animation_smear)
		print(animation)
		toggle_damage_collisions(attack_type)

func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	if attack_type == "air":
		wait_time = 0.4
	elif attack_type == "single":
		wait_time = 0.5
	elif attack_type == "double":
		wait_time = 0.8
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
