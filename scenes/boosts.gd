extends Node3D

@export var boost_number_cap: int = 50

@onready var boost_resource: PackedScene = preload("res://objects/boost.tscn")


func num_boosts() -> int:
	print(get_child_count())
	return get_child_count()


func spawn_boost(point: Vector3) -> void:
	if num_boosts() >= boost_number_cap:
		return
	# raycast cast down to find the ground
	var raycast = RayCast3D.new()
	add_child(raycast)
	raycast.position = point
	raycast.target_position = Vector3(0, -100, 0)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		print("cringe")
		var boost = boost_resource.instantiate()
		boost.position = point
		add_child(boost)
	remove_child(raycast)
