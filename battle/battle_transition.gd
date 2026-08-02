extends CanvasLayer

func play_enter_start(enemy_sprite: Texture2D):
	get_tree().paused = true
	
	$EnemySpriteContainer/EnemySprite.texture = enemy_sprite
	
	$AnimationPlayer.play("battle_enter_start")
	await $AnimationPlayer.animation_finished
	
	get_tree().call_deferred("change_scene_to_file", Scene.BATTLE)

func play_enter_end():
	$AnimationPlayer.play("battle_enter_end")
	await $AnimationPlayer.animation_finished
	
	get_tree().paused = false
	queue_free()
