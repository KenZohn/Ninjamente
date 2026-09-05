@tool
extends HBoxContainer

@export_enum("confirm", "cancel", "skill") var action: String = "confirm":
	set(value):
		action = value
		update_visual()

@export var text: String:
	set(value):
		text = value
		update_visual()

@export var icon: Texture2D:
	set(value):
		icon = value
		update_visual()

const KEYBOARD_ICONS = {
	"confirm": preload("res://asset/NinjaAdventure/Ui/Input/Keyboard/KeyZ.png"),
	"cancel": preload("res://asset/NinjaAdventure/Ui/Input/Keyboard/KeyX.png"),
	"skill": preload("res://asset/NinjaAdventure/Ui/Input/Keyboard/KeyK.png")
}

const CONTROLLER_ICONS = {
	"confirm": preload("res://asset/NinjaAdventure/Ui/Input/Gamepad/ButtonA/Idle.png"),
	"cancel": preload("res://asset/NinjaAdventure/Ui/Input/Gamepad/ButtonB/Idle.png"),
	"skill": preload("res://asset/NinjaAdventure/Ui/Input/Gamepad/Select.png")
}

func _ready() -> void:
	if Engine.is_editor_hint():
		update_visual(InputManager.InputType.KEYBOARD)
		return
	
	InputManager.input_type_changed.connect(_on_input_type_changed)
	update_visual(InputManager.current_input_type)

func _on_input_type_changed(input_type: InputManager.InputType) -> void:
	update_visual(input_type)

func update_visual(input_type = InputManager.InputType.KEYBOARD) -> void:
	if not has_node("IconContainer/InputIcon") or not has_node("Label"):
		return
	
	if icon != null:
		$ActionIcon.texture = icon
		$ActionIcon.show()
		$Label.hide()
	else:
		$ActionIcon.hide()
		$Label.show()
		$Label.text = text
	
	match input_type:
		InputManager.InputType.KEYBOARD:
			$IconContainer/InputIcon.texture = KEYBOARD_ICONS[action]
	
		InputManager.InputType.CONTROLLER:
			$IconContainer/InputIcon.texture = CONTROLLER_ICONS[action]
