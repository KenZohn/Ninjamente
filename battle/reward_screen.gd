extends CanvasLayer

signal continue_pressed

func _ready():
	AudioManager.stop_bgm()
	
	$Background/ContinueButton/Background/Button.grab_focus()

func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
	queue_free()

func show_reward(xp: int, coin: int, leveled_up: bool):
	$Background/XPReward/XPValue.text = "+ " + str(xp)
	$Background/CoinReward/CoinValue.text = "+ " + str(coin)
	
	if leveled_up:
		$LevelUpIcon.visible = true
		
		AudioManager.play_sound(Audio.LEVEL_UP)
		$AnimationPlayer.play("level_up")
	else:
		AudioManager.play_sound(Audio.VICTORY)
