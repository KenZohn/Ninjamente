extends Control

@onready var player = $BattleFieldFrame/BattleField/Player
@onready var enemy = $BattleFieldFrame/BattleField/Enemy

var player_data
var enemy_data

func _ready() -> void:
	player_data = BattleManager.player_data
	enemy_data = BattleManager.enemy_data
	
	player.setup(player_data)
	enemy.setup(enemy_data)
	
	$HUD/HeartBar.setup(player_data.max_hp, player_data.current_hp)
	
	$Menu/AttackButton/Background/Button.grab_focus()
	
	var transition = preload(Scene.BATTLETRANSITION).instantiate()
	add_child(transition)
	
	transition.play_enter_end()

func _on_attack_button_pressed() -> void:
	await enemy.take_damage(player_data.damage)
	
	player.take_damage(enemy_data.damage)
	$HUD/HeartBar.update_hearts(player_data.current_hp)

func _on_run_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", Scene.MAP)
