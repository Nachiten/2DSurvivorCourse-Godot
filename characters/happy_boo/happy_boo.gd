extends Node2D


func play_idle_animation() -> void:
	%AnimationPlayer.play("idle")

func play_walk_animation() -> void:
	%AnimationPlayer.play("walk")
