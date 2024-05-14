extends Node2D

@onready var animation_player = %AnimationPlayer

func play_walk():
	animation_player.play("walk")

func play_hurt():
	animation_player.play("hurt")
	animation_player.queue("walk")
