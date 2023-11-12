extends Node3D


func explode():
	$Audio.play()
	$Particles.emitting = true


func _process(_delta: float):
	if $Particles.emitting or $Audio.playing:
		return
	queue_free()
