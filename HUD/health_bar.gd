extends Control

const PIXELS_PER_HP := 3.0
const MAX_BAR_WIDTH := 170.0

var background_width: float
var max_hp: int

func setup(_max_hp: int, current_hp: int):
	max_hp = _max_hp
	
	background_width = min(
		max_hp * PIXELS_PER_HP,
		MAX_BAR_WIDTH
	)
	
	$Border.size.y = background_width + 8
	$Background.size.y = background_width + 6
	
	update_health_bar(current_hp)

func update_health_bar(current_hp: int):
	var fill_width := (float(current_hp) / max_hp) * background_width
	
	$Fill.size.y = fill_width
