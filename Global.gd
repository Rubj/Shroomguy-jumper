extends Node

var playerBody: CharacterBody2D

var selectedCharacter: int = 0

var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D

var kukkSightZone: Area2D


var current_checkpoint : Checkpoint

func respawn_player():
	if current_checkpoint != null:
		playerBody.global_position = current_checkpoint.global_position

