extends Node2D

signal coinCollected

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("coinCollected")
		$CoindropAudio.play(0.0)
		$AnimationPlayer.play("GetCoin")

