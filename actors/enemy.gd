class_name Enemy
extends CharacterBody3D

const SPEED = 5.0
const TIME_PER_ACTION = 4.0
const DISTANCE = 1000  #This is distance squared

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player_position: Vector3
var direction: Vector3

var time_since_last_action_pick: float = 0.0
var random_direction = Vector3.ZERO
var fire_explosion = preload("res://objects/firexplosion.tscn")


func update_player_position(pos: Vector3):
	player_position = pos


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var distance = position.distance_squared_to(player_position)

	if distance < DISTANCE:
		direction = position.direction_to(player_position)
	else:
		time_since_last_action_pick += delta
		if time_since_last_action_pick > TIME_PER_ACTION:
			time_since_last_action_pick -= TIME_PER_ACTION
			direction.x = randf()
			direction.z = randf()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()


func explode():
	var explosion = fire_explosion.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	explosion.explode()
