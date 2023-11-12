extends Node3D

@onready var tree_resource: PackedScene = preload("res://objects/tree.tscn")


func spawn_tree(point: Vector3) -> void:
	# raycast cast down to find the ground
	var raycast = RayCast3D.new()
	add_child(raycast)
	raycast.position = point
	raycast.target_position = Vector3(0, -100, 0)
	raycast.force_raycast_update()
	if raycast.is_colliding() and not raycast.get_collider().is_in_group("procedural"):
		var spawn_point = raycast.get_collision_point()
		var tree = tree_resource.instantiate()
		tree.position = spawn_point
		add_child(tree)
	remove_child(raycast)
