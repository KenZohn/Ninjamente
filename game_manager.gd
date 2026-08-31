extends Node

var coins: int = 0
var level = 1
var current_xp: int = 0
var next_level_xp: int = 10

func add_xp(amount: int):
	var leveled_up = false
	
	current_xp += amount
	
	while current_xp >= next_level_xp:
		current_xp -= next_level_xp
		level += 1
		next_level_xp = calculate_next_level_xp(level)
		leveled_up = true
		
		# Provisório
		BattleManager.player_data.damage += 1
		BattleManager.player_data.current_hp = BattleManager.player_data.max_hp
	
	return leveled_up

func calculate_next_level_xp(target_level: int) -> int:
	return 10 * (2 ** (target_level - 1))
