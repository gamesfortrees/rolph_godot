extends MarginContainer

onready var game_controller := get_node("/root/GameController")
export var first_scene: PackedScene

func _on_Easy_button_up() -> void:
	game_controller.set_difficult(false)
	get_tree().change_scene_to(first_scene)


func _on_Difficult_button_up() -> void:
	game_controller.set_difficult(true)
	get_tree().change_scene_to(first_scene)
