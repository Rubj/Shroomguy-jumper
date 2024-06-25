extends CharacterBody2D

class_name KukkEnemy

@onready var ap = $AnimationPlayer

const speed_max = 70

var dir: Vector2
var is_chasing_player: bool = false
var is_roaming: bool = true

const gravity = 800
var knockback = -10.0
var knockback_max = -400.0
var health = 80
var health_max = 80
var health_min = 0

var acceleration = 0.25
var friction = 0.1

var dead = false
var taking_damage = false

var player: CharacterBody2D


func _process(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
		#velocity.x = 0
	if velocity.y > 1500:
		velocity.y = 1500
	
	player = Global.playerBody
	
	move(delta)
	move_and_slide()
	handle_animation()

func move(delta):
	if !dead:
		if !is_chasing_player and !taking_damage:
			velocity += dir * speed_max * delta
		elif !is_chasing_player and take_damage:
			var knockback_dir = position.direction_to(player.global_position) * lerp(knockback_max, knockback, 0.7)
			velocity.x = lerp(knockback_dir.x, 0.0, friction)
			velocity.y = (gravity - gravity) + lerp(-25.0, 0.0, 0.3)
		elif is_chasing_player and !taking_damage:
			var dir_to_player = position.direction_to(player.global_position) * speed_max
			velocity.x = lerpf(dir_to_player.x, speed_max, acceleration)
			dir.x = abs(velocity.x) / velocity.x
			velocity.x = clamp(velocity.x, -speed_max, speed_max)
		elif take_damage:
			var knockback_dir = position.direction_to(player.global_position) * lerp(knockback_max, knockback, 0.7)
			velocity.x = lerp(knockback_dir.x, 0.0, friction)
			velocity.y = (gravity - gravity) + lerp(-25.0, 0.0, 0.3)
		is_roaming = true
	elif dead:
		velocity.x = 0
		velocity.y = (gravity - gravity) -15

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_chasing_player:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()

func _on_kukk_hitbox_area_entered(area):
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= health_min:
		health = health_min
		dead = true
	print(str(self), "current health is ", health)

func handle_animation():
	var sprite = $Sprite2D
	if !dead and !taking_damage:
		ap.play("idle")
		if dir.x == 1:
			sprite.flip_h = true
		elif dir.x == -1:
				sprite.flip_h = false
	elif !dead and taking_damage:
		ap.play("hurt")
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		ap.play('death')
		await get_tree().create_timer(1.0).timeout
		handle_death()

func handle_death():
	self.queue_free()

func _on_kukk_sight_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_chasing_player = true
		print("player nähtud")
func _on_kukk_sight_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_chasing_player = false
		print("player kadunud")
