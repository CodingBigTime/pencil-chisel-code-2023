extends CharacterBody3D

const SPEED = 5.0
const TIME_PER_ACTION = 8000
const DISTANCE = 1000  #This is distance squared

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player_position_global: Vector3

var time_since_last_action_pick = 0
var random_direction = Vector3.ZERO


func update_player_position(position: Vector3):
	player_position_global = position


func _ready():
	add_to_group("enemies")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var distance = global_position.distance_squared_to(player_position_global)

	if distance < DISTANCE:
		var direction = global_position.direction_to(player_position_global)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		delta += time_since_last_action_pick
		if time_since_last_action_pick > TIME_PER_ACTION:
			random_direction.x = randf()
			random_direction.y = randf()
			time_since_last_action_pick = 0
		velocity.x = random_direction.x * SPEED
		velocity.z = random_direction.y * SPEED

	move_and_slide()
