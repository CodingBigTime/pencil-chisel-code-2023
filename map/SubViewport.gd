extends SubViewport


func set_data(pos):
	$left.position = Vector2(pos.x + 180, pos.z + 180)


func _proccess(_delta):
	pass
