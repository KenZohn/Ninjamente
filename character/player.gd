extends CharacterBody2D

var speed = 70.0
var last_direction = "down"

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
		if direction.y < 0:
			$Sprite.play("walk_up")
			last_direction = "up"
		elif direction.y > 0:
			$Sprite.play("walk_down")
			last_direction = "down"
		elif direction.x < 0:
			$Sprite.play("walk_left")
			last_direction = "left"
		elif direction.x > 0:
			$Sprite.play("walk_right")
			last_direction = "right"
	else:
		$Sprite.play("idle_" + last_direction)
