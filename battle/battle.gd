extends Control

func _ready() -> void:
	$Menu/AttackButton/Background/Button.grab_focus()
	
	$BattleFieldFrame/BattleField/Enemy.setup(BattleManager.enemy_data)
	
	var transition = preload(Scene.BATTLETRANSITION).instantiate()
	add_child(transition)
	
	transition.play_enter_end()

func _on_attack_button_pressed() -> void:
	await $BattleFieldFrame/BattleField/Enemy.show_text(str(2), "damage")
	await $BattleFieldFrame/BattleField/Player.show_text(str(BattleManager.enemy_data.damage), "damage")
