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
	if collider_name != name or launched:
		return
	launched = true
	gravity_scale = 1
	apply_impulse(velocity)

	var sound_player = AudioStreamPlayer3D.new()
	sound_player.stream = load("res://assets/sfx/push_ice.wav")
	add_child(sound_player)
	sound_player.play()

	$GPUParticles3D.emitting = true


func _physics_process(_delta: float):
	if not launched:
		return
	$RayCast3D.position = self.position
	if $RayCast3D.is_colliding():
		var coliding_with = $RayCast3D.get_collision_point().y
		position.y = lerp(position.y, coliding_with, 0.1)