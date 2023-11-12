extends Node3D


func _ready():
	$player.die.connect(go_to_main_menu)
	$player.boost_count_changed.connect($main_ui/AspectRatioContainer/boost_bar.update_value)
	$player.boost_count_changed.emit($player.boost_count)
	$player.increase_score.connect($main_ui/AspectRatioContainer2/score_label.increase_score)
	$player.location_feet.connect($map/SubViewportContainer/SubViewport.set_data)


func go_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
