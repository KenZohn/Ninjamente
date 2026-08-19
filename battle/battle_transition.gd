extends CanvasLayer

func play_enter_start(enemy_sprite: Texture2D):
	$EnemySpriteContainer/EnemySprite.texture = enemy_sprite
	
	AudioManager.play_sound(Audio.START_BATTLE)
	$AnimationPlayer.play("battle_enter_start")
	await $AnimationPlayer.animation_finished

func play_enter_end():
	$AnimationPlayer.play("battle_enter_end")
	await $AnimationPlayer.animation_finished
	
	queue_free()
