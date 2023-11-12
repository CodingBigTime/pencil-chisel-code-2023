extends Node3D


var death_sounds = [
	preload("res://assets/sfx/explosion_1.wav"),
	preload("res://assets/sfx/explosion_2.wav"),
	preload("res://assets/sfx/explosion_3.wav")
]

func explode():
	$Audio.stream = death_sounds[randi() % death_sounds.size()]
	$Audio.pitch_scale = 0.8 + randf() * 0.4
	$Audio.play()
	$Particles.emitting = true


func _process(_delta: float):
	if $Particles.emitting or $Audio.playing:
		return
	queue_free()
