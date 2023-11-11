extends Node3D

var launched = false


func _ready():
	var player_node = get_node_or_null("/root/Map/player")
	if player_node:
		player_node.connect("launch_weapon", _launch)
	else:
		print("Player node not found")


func _launch(collider_name, velocity):
	# var player_node = get_node_or_null("/root/Map/player")
	# print(self.name)
	# print(collider_name)
	if collider_name == name and not launched:
		launched = true
		var rb = get_node("RigidBody3D")
		rb.gravity_scale = 1
		rb.apply_impulse(velocity)
