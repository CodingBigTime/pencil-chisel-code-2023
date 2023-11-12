extends RigidBody3D

signal enemy_killed

var launched = false
var ice_explosion = preload("res://objects/icexplosion.tscn")


func _ready():
	var player_node = get_node_or_null("/root/Map/player")
	var timer = $Timer
	timer.connect("timeout", _on_Timer_timeout)
	if player_node:
		player_node.connect("launch_weapon", _launch)
	else:
		print("Player node not found")


func _launch(collider_name, velocity):
	if collider_name != name or launched:
		return
	launched = true
	gravity_scale = 1
	apply_impulse(velocity)
	$Timer.start()
	$AnimationPlayer.play("explosion_windup")
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


func _on_Timer_timeout():
	explode()
	queue_free()


func explode():
	var explosion = ice_explosion.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	explosion.play_sound()
	var overlapping_bodies = $Area3D.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("enemy"):
			body.queue_free()
			enemy_killed.emit()
