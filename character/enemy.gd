extends CharacterBody2D

@export var patrol_path: Node2D
@export var wait_time := 2.0
@export var speed := 40.0
@export var data: EnemyData

var last_direction = "down"
var current_point := 0
var waiting := false

func _physics_process(_delta):
	var direction := Vector2.ZERO
	
	if waiting or patrol_path == null:
		velocity = Vector2.ZERO
	else:
		var target = patrol_path.get_child(current_point).global_position
		direction = global_position.direction_to(target)
		
		velocity = direction * speed
		
		if global_position.distance_to(target) < 5:
			velocity = Vector2.ZERO
			waiting = true
			$Timer.start(wait_time)
	
	move_and_slide()
	update_animation(direction)

func _on_timer_timeout():
	current_point = (current_point + 1) % patrol_path.get_child_count()
	waiting = false

func update_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				last_direction = "right"
			else:
				last_direction = "left"
		else:
			if direction.y > 0:
				last_direction = "down"
			else:
				last_direction = "up"
		$Sprite.play("walk_" + last_direction)
	else:
		$Sprite.play("idle_" + last_direction)

func _on_battle_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_battle()

func start_battle():
	BattleManager.enemy_data = data
	
	var transition = preload(Scene.BATTLETRANSITION).instantiate()
	add_child(transition)
	
	transition.play_enter_start(data.transition_sprite)
