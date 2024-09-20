extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false
var checkpoint_changing: bool

func activate():
	checkpoint_changing = true
	$AnimationPlayer.play("checkpoint_reached")
	#if (!checkpoint_changing):
	$AnimationPlayer.queue("checkpoint_checked")
	activated = true
	Global.current_checkpoint = self

func deactivate():
	#$AnimationPlayer.clear_queue()
	$AnimationPlayer.play("checkpoint_deactivate")
	#if (!checkpoint_changing):
	activated = false
	$AnimationPlayer.queue("checkpoint_default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !activated:
		if Global.current_checkpoint != null:
			Global.current_checkpoint.deactivate()
		activate()
