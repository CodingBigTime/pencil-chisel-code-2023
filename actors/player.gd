class_name Player
extends RigidBody3D

signal launch_weapon(weapon_name, launch_strength)
signal boost_count_changed(new_value)
signal increase_score_signal(amount)
signal die

signal player_position_changed(position: Vector3)

const BOOST_SPEED = 5
const LAUNCH_FORCE = 0.7
const ROTATION_SPEED = 5
const MAX_VELOCITY = 80.0

@export var starting_boost_count: int = 0
var starting_position: Vector3
var boost_count: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var ski_sounds = [
	preload("res://assets/sfx/ski_1.wav"),
	preload("res://assets/sfx/ski_2.wav"),
	preload("res://assets/sfx/ski_3.wav")
]


func _ready():
	starting_position = position
	boost_count = starting_boost_count
	boost_count_changed.emit(boost_count)


func add_boost_count(value):
	boost_count += value
	boost_count_changed.emit(boost_count)


func boost():
	if boost_count <= 0:
		return
	linear_velocity += (Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), rotation.y) * BOOST_SPEED)
	boost_count -= 1
	boost_count_changed.emit(boost_count)
	if not $AudioPlayer.playing:
		$AudioPlayer.stream = ski_sounds[randi() % ski_sounds.size()]
		$AudioPlayer.pitch_scale = 0.8 + randf() * 0.4
		$AudioPlayer.play()


func increase_score(amount: int = 1):
	increase_score_signal.emit(amount)


func _physics_process(delta: float):
	get_tree().call_group("enemy", "update_player_position", global_position)

	if position.y < -70 or Input.is_action_just_pressed("menu"):
		die.emit()

	var input_rotation = Input.get_action_strength("right") - Input.get_action_strength("left")
	rotate(Vector3(0, -1, 0), input_rotation * delta * ROTATION_SPEED)

	var velocity_xz = Vector2(linear_velocity.x, linear_velocity.z)
	var polar_xz = Trigonometry.to_polar(velocity_xz)
	polar_xz.y = -get_rotation().y - PI / 2
	var velocity_xz_rotated = Trigonometry.to_cartasian(polar_xz)
	linear_velocity.x = velocity_xz_rotated.x
	linear_velocity.z = velocity_xz_rotated.y

	if Input.is_action_just_pressed("boost"):
		boost()

	# Handle collision
	for body in get_colliding_bodies():
		if body.is_in_group("weapon"):
			launch_weapon.emit(body.name, linear_velocity * LAUNCH_FORCE)

	velocity_xz = Vector2(linear_velocity.x, linear_velocity.z)
	var velocity_xz_clamped = Trigonometry.clamp_vector_2d(velocity_xz, MAX_VELOCITY)
	linear_velocity.x = velocity_xz_clamped.x
	linear_velocity.z = velocity_xz_clamped.y

	do_particles(linear_velocity.x, linear_velocity.z)

	if $RayCast3D_far.is_colliding():
		position.y = lerp(position.y, $RayCast3D_far.get_collision_point().y + 0.05, 0.1)
		linear_velocity.x += 0.1

		if $RayCast3D_close.is_colliding():
			# rotate $pingu to be normal to the surface, use rotation.y as well
			var collision_normal: Vector3 = $RayCast3D_far.get_collision_normal()
			$pingu.global_transform = Trigonometry.align_with_y(
				$pingu.global_transform, collision_normal
			)
			$pingu.rotation.y = 0

	player_position_changed.emit(position)


func do_particles(l_x, l_z):
	var total_velocity = abs(l_x) + abs(l_z)
	if total_velocity < 2:
		$GPUParticles3D.emitting = false
	elif total_velocity > 2 and total_velocity < 5:
		$GPUParticles3D.emitting = true
		$GPUParticles3D.amount = 10
	elif total_velocity > 5 and total_velocity < 10:
		$GPUParticles3D.emitting = true
		$GPUParticles3D.amount = 40
	elif total_velocity > 10:
		$GPUParticles3D.emitting = true
		$GPUParticles3D.amount = 80


func _on_body_entered(body: Node):
	if body.is_in_group("weapon"):
		launch_weapon.emit(body.name, linear_velocity * LAUNCH_FORCE)
	if body.is_in_group("enemy"):
		die.emit()


func _on_timer_timeout():
	add_boost_count(1)
