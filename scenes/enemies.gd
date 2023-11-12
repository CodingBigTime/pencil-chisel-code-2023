extends Node3D

signal enemy_killed_signal

@export var despawn_distance: int = 80
@export var enemy_number_cap: int = 10

var player_position: Vector3 = Vector3(0, 0, 0)
@onready var enemy_resource: PackedScene = preload("res://actors/enemy.tscn")


func num_enemies() -> int:
	print(get_child_count())
	return get_child_count()


func spawn_enemy(point: Vector3) -> void:
	if num_enemies() > enemy_number_cap:
		return
	# raycast cast down to find the ground
	var raycast = RayCast3D.new()
	add_child(raycast)
	raycast.position = player_position + point
	raycast.target_position = Vector3(0, -100, 0)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		# var spawn_point = raycast.get_collision_point()
		var enemy = enemy_resource.instantiate()
		enemy.position = player_position + point
		add_child(enemy)
	remove_child(raycast)


func update_player_position(pos: Vector3) -> void:
	player_position = pos


func _process(_delta: float) -> void:
	for child in get_children():
		if child.is_in_group("enemy"):
			var enemy = child as Enemy
			if enemy.position.distance_to(player_position) > 80:
				remove_child(enemy)
				enemy.queue_free()
