extends RigidBody3D

signal launch_weapon(weapon_name, launch_strength)

const BOOST_SPEED = 20.0
const LAUNCH_FORCE = 1.0
const ROTATION_SPEED = 2.0
const MAX_VELOCITY = 100.0
const TERMINAL_VELOCITY = 20.0

var starting_position: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	starting_position = position


func boost():
	linear_velocity += (Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), rotation.y) * BOOST_SPEED)


func _physics_process(delta: float):
	if Input.is_action_just_pressed("reset"):
		position = starting_position
		linear_velocity = Vector3(0, 0, 0)
		angular_velocity = Vector3(0, 0, 0)
		rotation = Vector3(0, 0, 0)

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
			launch_weapon.emit(body.get_parent().name, linear_velocity * LAUNCH_FORCE)
			linear_velocity *= 0.5

	velocity_xz = Vector2(linear_velocity.x, linear_velocity.z)
	var velocity_xz_clamped = Trigonometry.clamp_vector_2d(velocity_xz, MAX_VELOCITY)
	linear_velocity.x = velocity_xz_clamped.x
	linear_velocity.z = velocity_xz_clamped.y

	if $RayCast3D_far.is_colliding() and not $RayCast3D_close.is_colliding():
		position.y = lerp(position.y, $RayCast3D_far.get_collision_point().y + 0.5, 0.1)
