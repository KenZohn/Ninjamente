extends Control

signal health_changed(current_hp: int)

const FLOATING_TEXT_SCENE = preload(Scene.FLOATINGTEXT)

var data

func setup(_data):
	data = _data
	$Sprite.texture = data.battle_sprite

func show_text(text: String, type: String):
	var floating_text = FLOATING_TEXT_SCENE.instantiate()
	
	add_child(floating_text)
	await floating_text.play(text, type)

func take_damage(amount: int):
	data.current_hp = max(data.current_hp - amount, 0)
	
	health_changed.emit(data.current_hp)
	
	await show_text(str(amount), "damage")
