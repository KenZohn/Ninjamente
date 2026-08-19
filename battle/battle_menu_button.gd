extends Control

signal pressed

func _ready():
	$Background/Button.pressed.connect(_on_button_pressed)

func _on_button_focus_entered() -> void:
	AudioManager.play_sound(Audio.MENU_MOVE)
	$AnimationPlayer.play("focus")
	$Cursor.visible = true

func _on_button_focus_exited() -> void:
	$AnimationPlayer.play("RESET")
	$Cursor.visible = false

func _on_button_pressed() -> void:
	AudioManager.play_sound(Audio.MENU_CONFIRM)
	pressed.emit()
