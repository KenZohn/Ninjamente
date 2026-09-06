extends Resource
class_name SkillData

enum Effect {
	INCREASE_MAX_HP,
	INCREASE_DAMAGE,
	SHURIKEN
}

@export var skill_name: String
@export var description: String
@export var icon: Texture2D
@export var locked_icon: Texture2D
@export var effect: Effect
@export var value: int = 0
