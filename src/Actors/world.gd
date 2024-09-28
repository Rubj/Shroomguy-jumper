extends Node2D

@onready var scene_transition_ap: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer

func _ready() -> void:
	scene_transition_ap.get_parent().get_node("ColorRect").color.a = 255
	scene_transition_ap.play("fade_out")
