extends RigidBody3D

const BOOST_VALUE = 3


func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		body.add_boost_count(BOOST_VALUE)
		queue_free()
