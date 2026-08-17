extends Control

signal health_changed(current_hp: int)

const FLOATING_TEXT_SCENE = preload(Scene.FLOATING_TEXT)

var data

func setup(_data):
	data = _data
	$Visual/Sprite.texture = data.battle_sprite

func show_text(text: String, type: String):
	var floating_text = FLOATING_TEXT_SCENE.instantiate()
	
	add_child(floating_text)
	await floating_text.play(text, type)

func take_damage(amount: int):
	data.current_hp = max(data.current_hp - amount, 0)
	
	health_changed.emit(data.current_hp)
	
	$AnimationPlayer.play("take_damage")
	
	await show_text(str(amount), "damage")

func normal_attack():
	$AnimationPlayer.play("normal_attack")
	await $AnimationPlayer.animation_finished

func normal_attack_end():
	$AnimationPlayer.play("normal_attack_end")
	await $AnimationPlayer.animation_finished
