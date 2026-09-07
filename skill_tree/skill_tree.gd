extends CanvasLayer

@onready var skill_status = $Description/SkillStatus
@onready var confirm_hint = $Description/SkillStatus/ConfirmHint
@onready var status_label = $Description/SkillStatus/StatusLabel

signal closed

func _ready() -> void:
	for skill in $SkillArea/Skills.get_children():
		if skill is not Skill:
			continue
		
		skill.focused.connect(_on_skill_focused)
		skill.pressed_skill.connect(_on_skill_pressed)
		
		update_skill_state(skill)
	
	update_available_skills()
	create_connections()
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
			update_available_skills()
			update_connections()
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

#region Skill Connections

var connections = [
	["IncreaseMaxHP01", "IncreaseDamage01"],
	["IncreaseDamage01", "IncreaseDamage02"],
	["IncreaseDamage01", "IncreaseMaxHP02"],
	["IncreaseDamage02", "Shuriken01"]
]

func create_connections() -> void:
	for connection in connections:
		var skill_a = $SkillArea/Skills.get_node(connection[0])
		var skill_b = $SkillArea/Skills.get_node(connection[1])
		
		connect_skills(skill_a, skill_b)
	
	update_connections()

func connect_skills(skill_a: Skill, skill_b: Skill) -> void:
	var connection = Node2D.new()
	var border = Line2D.new()
	var line = Line2D.new()
	
	$SkillArea/Skills/Connections.add_child(connection)
	
	connection.add_child(border)
	connection.add_child(line)
	
	var center_a = skill_a.position + skill_a.size / 2
	var center_b = skill_b.position + skill_b.size / 2
	
	var points = PackedVector2Array([
		center_a,
		center_b
	])
	
	border.width = 6.0
	border.default_color = Color("263636")
	border.points = points
	
	line.width = 4.0
	line.points = points
	
	connection.set_meta("skill_a", skill_a)
	connection.set_meta("skill_b", skill_b)
	
	update_connections()

func update_connections() -> void:
	for connection in $SkillArea/Skills/Connections.get_children():
		var skill_a = connection.get_meta("skill_a")
		var skill_b = connection.get_meta("skill_b")
		var line = connection.get_child(1)
		
		if skill_a.state == Skill.State.ACQUIRED and skill_b.state == Skill.State.ACQUIRED:
			line.default_color = Color("bee2c0")
		
		elif (
			skill_a.state == Skill.State.ACQUIRED
			and skill_b.state == Skill.State.AVAILABLE
		) or (
			skill_a.state == Skill.State.AVAILABLE
			and skill_b.state == Skill.State.ACQUIRED
		):
			line.default_color = Color("758A73")
		
		else:
			line.default_color = Color("2b3126")

func update_available_skills() -> void:
	for skill in $SkillArea/Skills.get_children():
		if skill is not Skill or skill.state != Skill.State.LOCKED:
			continue
		
		for connection in connections:
			var skill_a = connection[0]
			var skill_b = connection[1]
			
			if skill.name == skill_a:
				var connected_skill = $SkillArea/Skills.get_node(skill_b)
				
				if connected_skill.state == Skill.State.ACQUIRED:
					skill.state = Skill.State.AVAILABLE
					break
			
			elif skill.name == skill_b:
				var connected_skill = $SkillArea/Skills.get_node(skill_a)
				
				if connected_skill.state == Skill.State.ACQUIRED:
					skill.state = Skill.State.AVAILABLE
					break

#endregion
