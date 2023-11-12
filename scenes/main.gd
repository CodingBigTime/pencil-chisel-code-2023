extends Node3D


func _ready():
	$player.die.connect(go_to_main_menu)
	$player.die.connect(GlobalState.make_game_over_visible)
	$player.boost_count_changed.connect($main_ui/AspectRatioContainer/boost_bar.update_value)
	$player.boost_count_changed.emit($player.boost_count)
	$player.increase_score_signal.connect($main_ui/AspectRatioContainer2/score_label.increase_score)
	$player.player_position_changed.connect($enemies.update_player_position)
	$glaciers.enemy_killed_signal.connect($player.increase_score)
	$AudioStreamPlayer3D.play()


func go_to_main_menu():
	$AudioStreamPlayer3D.stop()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
