extends Control

func play(text: String, animation: String):
	$Label.text = text
	$AnimationPlayer.play(animation)
	
	await $AnimationPlayer.animation_finished
	queue_free()
