extends CanvasLayer

@onready var skill_status = $Description/SkillStatus
@onready var confirm_hint = $Description/SkillStatus/ConfirmHint
@onready var status_label = $Description/SkillStatus/StatusLabel

signal closed

func _ready() -> void:
	for skill in $SkillArea/Skills.get_children():
		skill.focused.connect(_on_skill_focused)
		skill.pressed_skill.connect(_on_skill_pressed)
		
		update_skill_state(skill)
	
	update_skill_points(GameManager.skill_points)
	
	$SkillArea/Skills/IncreaseMaxHP01.grab_focus()
	_on_skill_focused($SkillArea/Skills/IncreaseMaxHP01)

func _on_skill_pressed(skill) -> void:
	if skill.state == Skill.State.AVAILABLE:
		if GameManager.skill_points >= 1:
			AudioManager.play_sound(Audio.CONFIRM)
			
			SkillManager.acquire_skill(skill.id, skill.data)
			GameManager.skill_points -= 1
			
			update_skill_state(skill)
			update_skill_points(GameManager.skill_points)

func _on_skill_focused(skill) -> void:
	$Description/SkillName.text = skill.data.skill_name
	$Description/DescriptionText.text = skill.data.description
	
	update_skill_status(skill.state)
	center_on_skill(skill)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") or event.is_action_pressed("skill_tree"):
		get_viewport().set_input_as_handled()
		
		AudioManager.play_sound(Audio.CANCEL)
		
		closed.emit()
		queue_free()

func update_skill_state(skill) -> void:
	if SkillManager.has_skill(skill.id):
		skill.state = Skill.State.ACQUIRED
		
		update_skill_status(skill.state)

func update_skill_status(state: Skill.State) -> void:
	status_label.visible = true
	confirm_hint.visible = false
	skill_status.self_modulate = Color.WHITE
	
	match state:
		Skill.State.LOCKED:
			status_label.text = "BLOQUEADO"
		
		Skill.State.AVAILABLE:
			if GameManager.skill_points >= 1:
				status_label.visible = false
				confirm_hint.visible = true
				skill_status.self_modulate = Color(1.5, 1.5, 1.5)
			else:
				status_label.text = "INSUFICIENTE"
		
		Skill.State.ACQUIRED:
			status_label.text = "OBTIDO"

func update_skill_points(value) -> void:
	$SkillPoints/Value.text = str(value)

func center_on_skill(skill: Control) -> void:
	var area_center = $SkillArea.size / 2
	var skill_center = skill.position + skill.size / 2
	
	var target_position = area_center - skill_center
	
	var tween = create_tween()
	tween.tween_property(
		$SkillArea/Skills,
		"position",
		target_position,
		0.3
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
