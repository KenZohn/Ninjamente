extends Control

const FLOATING_TEXT_SCENE = preload(Scene.FLOATINGTEXT)

func setup(data):
	$Sprite.texture = data.battle_sprite

func show_text(text: String, type: String):
	var floating_text = FLOATING_TEXT_SCENE.instantiate()
	
	add_child(floating_text)
	await floating_text.play(text, type)
