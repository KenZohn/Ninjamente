extends CharacterBody2D

@export var data: PlayerData

var speed = 70.0
var last_direction = "down"

func _ready():
	BattleManager.player_data = data

func _physics_process(_delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	velocity = direction * speed
	move_and_slide()
	update_animation(direction)

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
