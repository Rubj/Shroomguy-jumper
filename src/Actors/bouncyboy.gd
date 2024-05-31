extends CharacterBody2D

@onready var ap = $AnimationPlayer
@export var bounce_force = 1000
var player

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	pass

func _on_bounce_zone_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		ap.play('bounce')
		await get_tree().create_timer(0.2).timeout
		$CollisionShape2D.scale.y = 0.1
		await get_tree().create_timer(0.4).timeout
		$CollisionShape2D.scale.y = 0.18
		player.velocity.y = -bounce_force

func _on_bounce_zone_body_exited(body: Node2D):
	pass
