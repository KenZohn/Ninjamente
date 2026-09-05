extends Node

enum InputType {
	KEYBOARD,
	CONTROLLER
}

var current_input_type := InputType.KEYBOARD

signal input_type_changed(input_type: InputType)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	var new_input_type: InputType
	
	if event is InputEventKey:
		new_input_type = InputType.KEYBOARD
		
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		new_input_type = InputType.CONTROLLER
		
	else:
		return
	
	if new_input_type != current_input_type:
		current_input_type = new_input_type
		input_type_changed.emit(current_input_type)
