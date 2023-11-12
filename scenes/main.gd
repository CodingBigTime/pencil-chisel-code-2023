extends Node3D


func _ready():
	$player.boost_count_changed.connect($main_ui/AspectRatioContainer/boost_bar.update_value)
	$player.boost_count_changed.emit($player.boost_count)
	$player.increase_score.connect($main_ui/AspectRatioContainer2/score_label.increase_score)
