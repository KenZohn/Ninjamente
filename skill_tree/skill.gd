@tool
class_name Skill
extends Button

@export var id: String

@export var data: SkillData:
	set(value):
		data = value
		update_visual()

@export var state: State = State.LOCKED:
	set(value):
		state = value
		update_visual()

signal focused(skill)
signal pressed_skill(skill)

enum State {
	LOCKED,
	AVAILABLE,
	ACQUIRED
}

func update_visual() -> void:
	if not data or not has_node("Icon"):
		return
	
	match state:
		State.LOCKED:
			$Icon.texture = data.locked_icon
			$Icon.modulate = Color(0.4, 0.4, 0.4)
			$Background.modulate = Color(0.5, 0.5, 0.5)
		
		State.AVAILABLE:
			$Icon.texture = data.icon
			$Icon.modulate = Color(0.4, 0.4, 0.4)
			$Background.modulate = Color(0.5, 0.5, 0.5)
		
		State.ACQUIRED:
			$Icon.texture = data.icon
			$Icon.modulate = Color(1, 1, 1)
			$Background.modulate = Color(2.0, 2.0, 2.0)

func _on_pressed() -> void:
	pressed_skill.emit(self)
	$Background.modulate = Color(3.0, 3.0, 2.0)

func _on_focus_entered() -> void:
	AudioManager.play_sound(Audio.MENU_MOVE)
	
	focused.emit(self)
	$Background.modulate = Color(3.0, 3.0, 2.0)

func _on_focus_exited() -> void:
	update_visual()
