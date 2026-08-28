extends NinePatchRect

const MAX_BAR_WIDTH := 50.0

func update_xp_bar(current_xp: int, next_level_xp: int, level: int):
	var xp_ratio := clampf(float(current_xp) / next_level_xp, 0.0, 1.0)
	var xp_percentage = xp_ratio * 100
	var fill_width := xp_ratio * MAX_BAR_WIDTH
	
	$XPPercentage.text = str(int(xp_percentage)) + "%"
	$Fill.size.x = fill_width
	$LevelIcon/LevelValue.text = str(level)
