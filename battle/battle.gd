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
	
	player.health_changed.connect($HUD/PlayerHeartBar.update_hearts)
	enemy.health_changed.connect($HUD/EnemyHealthBar.update_health_bar)
	
	$HUD/PlayerHeartBar.setup(player_data.max_hp, player_data.current_hp)
	$HUD/EnemyHealthBar.setup(enemy_data.max_hp, enemy_data.current_hp)
	
	$Menu/AttackButton/Background/Button.grab_focus()
	
	var transition = preload(Scene.BATTLETRANSITION).instantiate()
	add_child(transition)
	
	transition.play_enter_end()

func _on_attack_button_pressed() -> void:
	set_menu_visible(false)
	
	await enemy.take_damage(player_data.damage)
	await player.take_damage(enemy_data.damage)
	
	set_menu_visible(true)

func _on_run_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", Scene.MAP)

func set_menu_visible(show_menu: bool):
	$Menu/AttackButton.visible = show_menu
	$Menu/ItemButton.visible = show_menu
	$Menu/RunButton.visible = show_menu
	
	if show_menu:
		$Menu/AttackButton/Background/Button.grab_focus()
