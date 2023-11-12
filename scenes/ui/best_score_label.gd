class_name BestScoreLabel
extends Label


func _ready() -> void:
	if GlobalState.new_best_score:
		text = "New best score: " + str(GlobalState.get_best_score())
		label_settings.font_color = Color(1.0, 1.0, 0.0)
		GlobalState.new_best_score = false
	else:
		text = "Best score: " + str(GlobalState.get_best_score())
		label_settings.font_color = Color(1.0, 1.0, 1.0)
