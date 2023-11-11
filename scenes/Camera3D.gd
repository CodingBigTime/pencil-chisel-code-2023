extends Camera3D

const CAMERA_DISTANCE: float = 14


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player_position: Vector3 = $"../player".position

	var polar_coords = Trigonometry.to_polar(Vector2(player_position.x, player_position.z))

	polar_coords.x += CAMERA_DISTANCE

	var cart_coords = Trigonometry.to_cartasian(polar_coords)

	position.x = cart_coords.x
	position.y = player_position.y + 2
	position.z = cart_coords.y

	var camera_angle = Vector2(position.x, position.z).angle()
	rotation.y = -camera_angle + PI / 2
