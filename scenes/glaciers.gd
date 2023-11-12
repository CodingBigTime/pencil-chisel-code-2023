extends Node3D

signal enemy_killed_signal

@onready var glacier_resource: PackedScene = preload("res://objects/glacier.tscn")


func spawn_glacier(point: Vector3) -> void:
	# raycast cast down to find the ground
	var raycast = RayCast3D.new()
	add_child(raycast)
	raycast.position = point
	raycast.target_position = Vector3(0, -100, 0)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var spawn_point = raycast.get_collision_point()
		var glacier = glacier_resource.instantiate()
		glacier.enemy_killed.connect(enemy_killed)
		glacier.position = spawn_point
		add_child(glacier)
	remove_child(raycast)


func enemy_killed() -> void:
	enemy_killed_signal.emit()
