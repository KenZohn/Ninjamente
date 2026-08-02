extends Control

func _ready() -> void:
	$Menu/AttackButton/Background/Button.grab_focus()
	
	var transition = preload(Scene.BATTLETRANSITION).instantiate()
	add_child(transition)
	
	transition.play_enter_end()
