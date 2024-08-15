extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false
var ready_to_deactivate = false


func activate():
	Global.current_checkpoint = self
	activated = true
	$AnimationPlayer.play("checkpoint_reached")
	await get_tree().create_timer(2.6).timeout
	$AnimationPlayer.play("checkpoint_checked")

func deactivate():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !activated:
		activate()
