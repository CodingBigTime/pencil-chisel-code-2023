extends CharacterBody3D

signal launch_weapon(weapon_name, launch_strength)

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const LAUNCH_FORCE = 10
const ROTATION_SPEED = 2.0
const MAX_VELOCITY = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_rotation = Input.get_action_strength("right") - Input.get_action_strength("left")
	rotate(Vector3(0, -1, 0), input_rotation * delta * ROTATION_SPEED)

	# move forward
	velocity += (Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), rotation.y) * SPEED * delta)

	move_and_slide()

	# Handle collision
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("weapon"):
			launch_weapon.emit(collider.get_parent().name, velocity * LAUNCH_FORCE)

	velocity = Trigonometry.clamp_vector_3d(velocity, MAX_VELOCITY)
