extends Spawner

@export var spawn_period: float

var timer: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > spawn_period:
		timer -= spawn_period
		spawn.emit(random_point())
