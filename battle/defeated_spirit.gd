extends Control

func play():
	$AnimationPlayer.play("defeated")
	
	await $AnimationPlayer.animation_finished
	queue_free()
