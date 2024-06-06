extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
var paused = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$MarginContainer/VBoxContainer/Button/AnimationPlayer2.play("spinn")
		pausedMenu()

func pausedMenu():
	if paused:
		get_tree().paused = false
		pause_menu.visible = false
	else:
		get_tree().paused = true
		pause_menu.visible = true
	
	paused = ! paused

func _on_button_pressed() -> void:
	$MarginContainer/VBoxContainer/Button/AnimationPlayer2.play("spinn")
	pausedMenu()
	
