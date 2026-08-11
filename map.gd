extends Node2D

func _ready():
	$HUD/HeartBar.setup(BattleManager.player_data.max_hp, BattleManager.player_data.current_hp)
