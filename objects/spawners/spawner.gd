class_name Spawner
extends Node

signal spawn(point: Vector3)

@export var min_distance: float = 0.0
@export var max_distance: float
@export var height: float = 0.0


func random_point() -> Vector3:
	for i in range(1000):
		var x = randf_range(-max_distance, max_distance)
		var z = randf_range(-max_distance, max_distance)
		var dist = Vector2(x, z).length()
		if dist < min_distance or dist > max_distance:
			continue
		return Vector3(x, height, z)

	print("Failed to find a random point")
	return Vector3.ZERO
