extends CharacterBody3D

signal launch_weapon(weapon_name, launch_strength)

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const LAUNCH_FORCE = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = Vector3(input_dir.x, 0, input_dir.y)

	# Rotate to face moving direction
	if direction.length() > 0:
		direction = direction.normalized()
		look_at(global_transform.origin + direction, Vector3.UP)

	# Handle movement
	if direction.length() > 0:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		var lerp_factor = 0.1 * delta * 100
		velocity.x = lerp(velocity.x, 0.0, lerp_factor)
		velocity.z = lerp(velocity.z, 0.0, lerp_factor)
	# Move and slide
	move_and_slide()

	# Handle collision
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("weapon"):
			launch_weapon.emit(collider.get_parent().name, velocity * LAUNCH_FORCE)
