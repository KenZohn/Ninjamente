extends Control

func _ready() -> void:
	$Menu/AttackButton/Background/Button.grab_focus()
	
	var transition = preload(Scene.BATTLETRANSITION).instantiate()
	add_child(transition)
	
	transition.play_enter_end()
	
	set_sprite()

func set_sprite():
	$BattleFieldFrame/BattleField/EnemySpriteContainer/EnemySprite.texture = BattleManager.enemy_data.battle_sprite
