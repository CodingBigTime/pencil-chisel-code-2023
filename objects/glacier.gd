extends RigidBody3D

var launched = false


func _ready():
	var player_node = get_node_or_null("/root/Map/player")
	if player_node:
		player_node.connect("launch_weapon", _launch)
	else:
		print("Player node not found")


func _launch(collider_name, velocity):
	# var player_node = get_node_or_null("/root/Map/player")
	if collider_name == name and not launched:
		launched = true
		gravity_scale = 1
		apply_impulse(velocity)


func _physics_process(_delta: float):
	if launched:
		$RayCast3D.position = self.position
		if $RayCast3D.is_colliding():
			var coliding_with = $RayCast3D.get_collision_point().y
			position.y = lerp(position.y, coliding_with, 0.1)
