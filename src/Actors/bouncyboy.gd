extends CharacterBody2D

@onready var ap = $AnimationPlayer
@export var bounce_force = 1000
var player
var player_in_bounce_zone: bool

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	pass

func _on_bounce_zone_body_entered(body: Node2D):
	player_in_bounce_zone = true
	if body.is_in_group("Player"):
		ap.play('bounce')
		await get_tree().create_timer(0.2).timeout
		$CollisionShape2D.scale.y = 0.14
		await get_tree().create_timer(0.3).timeout
		$CollisionShape2D.scale.y = 0.18
		if player_in_bounce_zone:
			player.velocity.y = -bounce_force

func _on_bounce_zone_body_exited(body: Node2D):
	player_in_bounce_zone = false
