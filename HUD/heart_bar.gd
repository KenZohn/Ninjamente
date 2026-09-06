extends HBoxContainer

@export var heart_textures: Array[Texture2D]

const HEART_VALUE := 4

func setup(max_hp: int, current_hp: int):
	var total_hearts = ceili(max_hp / float(HEART_VALUE))
	
	create_hearts(total_hearts)
	update_hearts(current_hp)

func create_hearts(total_hearts: int):
	for child in get_children():
		child.free()
	
	for i in total_hearts:
		var heart := TextureRect.new()
		heart.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		add_child(heart)

func update_hearts(current_hp: int):
	var remaining_hp := current_hp
	
	for heart in get_children():
		var value = clamp(remaining_hp, 0, HEART_VALUE)
		heart.texture = heart_textures[value]
		remaining_hp -= HEART_VALUE
