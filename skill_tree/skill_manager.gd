extends Node

var acquired_skills: Dictionary = {}

func acquire_skill(id: String, data: SkillData) -> void:
	acquired_skills[id] = true
	
	apply_skill(data)

func has_skill(id: String) -> bool:
	return acquired_skills.get(id, false)

func apply_skill(data: SkillData) -> void:
	match data.effect:
		SkillData.Effect.INCREASE_MAX_HP:
			BattleManager.player_data.max_hp += data.value
			BattleManager.player_data.current_hp = min(
				BattleManager.player_data.current_hp + data.value,
				BattleManager.player_data.max_hp
			)
		
		SkillData.Effect.INCREASE_DAMAGE:
			BattleManager.player_data.damage += data.value
