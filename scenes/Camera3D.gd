extends Camera3D

const CAMERA_DISTANCE: float = 16
const MAX_FOV: float = 110
const LERP_SPEED: float = 5

var target_position: Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow_player(delta)


func follow_player(delta):
	var player_position: Vector3 = $"../player".position

	var polar_coords = Trigonometry.to_polar(Vector2(player_position.x, player_position.z))

	polar_coords.x += CAMERA_DISTANCE

	var cart_coords = Trigonometry.to_cartasian(polar_coords)

	target_position.x = cart_coords.x
	target_position.y = player_position.y + 0
	target_position.z = cart_coords.y

	var camera_angle = Vector2(position.x, position.z).angle()
	rotation.y = -camera_angle + PI / 2

	position = position.lerp(target_position, LERP_SPEED * delta)

	var player_speed = $"../player".linear_velocity.length()
	fov = min(lerpf(fov, 30 + player_speed * 2.5, 0.05), MAX_FOV)
