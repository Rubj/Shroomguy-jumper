extends CharacterBody2D

class_name KukkEnemy

@onready var ap = $AnimationPlayer

const speed = 50

var dir: Vector2
var is_chasing: bool = false
var is_roaming: bool = true


const gravity = 800
var knockback = -100
var health = 80
var health_max = 80
var health_min = 0

var dead = false
var taking_damage = false

var player: CharacterBody2D


func _process(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	if velocity.y > 1500:
		velocity.y = 1500
	
	player = Global.playerBody
	
	move(delta)
	move_and_slide()
	handle_animation()

func move(delta):
	if !dead:
		if !is_chasing:
			velocity += dir * speed * delta
		elif is_chasing and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x) / velocity.x
		elif take_damage:
			var knockback_dir = position.direction_to(player.position) * knockback
			velocity.x = knockback_dir.x
			velocity.y = (gravity - gravity) -15
		is_roaming = true
	elif dead:
		velocity.x = 0
		velocity.y = (gravity - gravity) -15

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_chasing:
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

