extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var game_controller = get_node("/root/level/GameController")

func _on_body_entered(body: PhysicsBody2D) -> void:
	game_controller.add_seed()
	anim_player.play("fade_out")
	