extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func play_walk() -> void:
	animation_player.play("walk")

func play_hurt() -> void:
	animation_player.play("hurt")
	animation_player.queue("walk")
