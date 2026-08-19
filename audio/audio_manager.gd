extends Node

const SOUND_EFFECT_SCENE = preload(Scene.SOUND_EFFECT)

func play_sound(sound_data: Dictionary):
	var audio = SOUND_EFFECT_SCENE.instantiate()
	add_child(audio)
	
	audio.stream = sound_data["sound"]
	audio.volume_db = sound_data.get("volume", 0.0)
	audio.play()
	audio.finished.connect(audio.queue_free)
