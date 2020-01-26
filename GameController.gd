extends Node

var count: int = 0
var game_over: bool = false

onready var count_label: Label = get_node("/root/level/UI/HUD/HBoxContainer/MarginContainer/count")
onready var game_over_ui: MarginContainer = get_node("/root/level/UI/GameOver")

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
	count_label.text = String(count)
	
func player_died() -> void:
	get_tree().paused = true
	game_over = true
	game_over_ui.visible = true
	
func restart_level() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()