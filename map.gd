extends Node2D

const BATTLE_TRANSITION_SCENE = preload(Scene.BATTLE_TRANSITION)
const BATTLE_SCENE = preload(Scene.BATTLE)

func _ready():
	AudioManager.play_bgm(Audio.MAP)
	
	$HUD/HeartBar.setup(BattleManager.player_data.max_hp, BattleManager.player_data.current_hp)
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.battle_requested.connect(_on_battle_requested)

func _on_battle_requested(enemy):
	get_tree().paused = true
	
	BattleManager.enemy_data = enemy.data.duplicate()
	BattleManager.current_enemy = enemy
	
	var battle_transition = BATTLE_TRANSITION_SCENE.instantiate()
	add_child(battle_transition)
	
	await battle_transition.play_enter_start(enemy.data.transition_sprite)
	
	var battle = BATTLE_SCENE.instantiate()
	add_child(battle)
	
	battle.battle_finished.connect(_on_battle_finished)
	
	await battle_transition.play_enter_end()

func _on_battle_finished():
	AudioManager.play_bgm(Audio.MAP)
	
	$HUD/HeartBar.update_hearts(BattleManager.player_data.current_hp)
	
	get_tree().paused = false
