class_name BestScoreLabel
extends Label

var best_score: int = 0


func _ready() -> void:
	text = "Best score: " + str(best_score)


func submit_new_score(new_score: int) -> void:
	if new_score > best_score:
		best_score = new_score
		text = "Best score: " + str(new_score)
