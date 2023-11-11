extends Node3D


func _ready():
	var player_node = get_node_or_null("/root/Map/player")
	if player_node:
			player_node.connect("launch_weapon", _launch)
	else:
		print("Player node not found")

func _launch(collider_name, launch_strength):
	var rb = get_node("RigidBody3D")
	rb.apply_impulse(Vector3(0, 0, -1) * launch_strength)
