extends Node

const SCORE_FILE = "user://score.save"

var new_best_score: bool = false


func get_best_score() -> int:
	var best_score: int
	if FileAccess.file_exists(SCORE_FILE):
		var file = FileAccess.open(SCORE_FILE, FileAccess.READ)
		best_score = file.get_var()
		file.close()
	else:
		best_score = 0
	return best_score


func set_best_score(new_score: int) -> void:
	var file = FileAccess.open(SCORE_FILE, FileAccess.WRITE)
	file.store_var(new_score)
	file.close()


func submit_new_score(new_score: int) -> void:
	if new_score > get_best_score():
		set_best_score(new_score)
		new_best_score = true
