extends Node

var count: int = 0
var game_over: bool = false
var triggered_dialogs: Array

func _physics_process(delta: float) -> void:
	if game_over and Input.is_action_just_pressed("jump"):
		restart_level()

func add_seed() -> void:
	_update_seeds(1)
	
func subtract_seed() -> bool:
	if count <= 0:
		return false
	_update_seeds(-1)
	return true
	
func _update_seeds(change: int) -> void:
	count += change
	var count_label := get_node("/root/level/UI/HUD/HBoxContainer/MarginContainer/count")
	count_label.text = String(count)
	
func player_died() -> void:
	get_tree().paused = true
	game_over = true
	var game_over_ui := get_node("/root/level/UI/GameOver")
	game_over_ui.visible = true
	
func restart_level() -> void:
	count = 0
	game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()