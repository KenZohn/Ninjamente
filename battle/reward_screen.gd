extends CanvasLayer

signal continue_pressed

func _ready():
	AudioManager.stop_bgm()
	AudioManager.play_sound(Audio.VICTORY)
	
	$Background/ContinueButton/Background/Button.grab_focus()

func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
	queue_free()
