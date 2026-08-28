extends CanvasLayer

@onready var player = $BattleFieldFrame/BattleField/Player
@onready var enemy = $BattleFieldFrame/BattleField/Enemy

signal battle_finished

var player_data
var enemy_data

func _ready() -> void:
	AudioManager.play_bgm(Audio.BATTLE)
	
	player_data = BattleManager.player_data
	enemy_data = BattleManager.enemy_data
	
	player.setup(player_data)
	enemy.setup(enemy_data)
	
	player.health_changed.connect($HUD/PlayerHeartBar.update_hearts)
	enemy.health_changed.connect($HUD/EnemyHealthBar.update_health_bar)
	
	$HUD/PlayerHeartBar.setup(player_data.max_hp, player_data.current_hp)
	$HUD/EnemyHealthBar.setup(enemy_data.max_hp, enemy_data.current_hp)
	
	$Menu/AttackButton/Background/Button.grab_focus()

func _on_attack_button_pressed() -> void:
	set_menu_visible(false)
	
	await get_tree().create_timer(0.2).timeout
	
	await player.normal_attack()
	player.normal_attack_end()
	await enemy.take_damage(player_data.damage)
	
	if enemy_data.current_hp <= 0:
		await enemy_defeated()
		await show_reward()
		end_battle()
		return
	
	await enemy.normal_attack()
	enemy.normal_attack_end()
	await player.take_damage(enemy_data.damage)
	
	if player_data.current_hp <= 0:
		end_battle()
		return
	
	set_menu_visible(true)

func _on_run_button_pressed() -> void:
	end_battle()

func set_menu_visible(show_menu: bool):
	$Menu/AttackButton.visible = show_menu
	$Menu/ItemButton.visible = show_menu
	$Menu/RunButton.visible = show_menu
	
	if show_menu:
		$Menu/AttackButton/Background/Button.grab_focus()

func enemy_defeated():
	await enemy.defeated()
	
	GameManager.coins += enemy_data.coin_reward
	GameManager.add_xp(enemy_data.xp_reward)
	
	if BattleManager.current_enemy:
		BattleManager.current_enemy.queue_free()
		BattleManager.current_enemy = null

func end_battle():
	battle_finished.emit()
	queue_free()

func show_reward():
	var reward_screen = preload(Scene.REWARD_SCREEN).instantiate()
	add_child(reward_screen)
	
	reward_screen.update_values(enemy_data.xp_reward, enemy_data.coin_reward)
	
	await reward_screen.continue_pressed
