extends Control


func _ready():
	get_window().size = Vector2(1280, 720)


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_butremove_meta():
	$ButtonDownSFX.play()


func _on_button_up():
	$ButtonUpSFX.play()
