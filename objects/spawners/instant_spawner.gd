extends Spawner

@export var spawn_count: int


func _ready():
	for i in range(spawn_count):
		spawn.emit(random_point())
