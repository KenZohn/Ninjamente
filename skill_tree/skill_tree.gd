extends CanvasLayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		get_viewport().set_input_as_handled()
		
		AudioManager.play_sound(Audio.CONFIRM)
		
	elif event.is_action_pressed("cancel") or event.is_action_pressed("skill_tree"):
		get_viewport().set_input_as_handled()
		
		AudioManager.play_sound(Audio.CANCEL)
		
		get_tree().paused = false
		queue_free()
