extends Control

func _on_button_focus_entered() -> void:
	$AnimationPlayer.play("focus")
	$Cursor.visible = true

func _on_button_focus_exited() -> void:
	$AnimationPlayer.play("RESET")
	$Cursor.visible = false
