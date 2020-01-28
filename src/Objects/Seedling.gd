extends Area2D

onready var player := get_node("/root/level/Player")
onready var chaser := get_node("/root/level/Chaser")
onready var game_controller := get_node("/root/GameController")
onready var plant := $plant
var have_seedling := false

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.get_name() == "Chaser" and plant.visible:
		yield(chaser.stop(), "completed")
		have_seedling = false
		plant.visible = false
		
		
func _physics_process(delta: float) -> void:
	if (
		!have_seedling and 
		game_controller.seeds > 0 and
		Input.is_action_just_pressed("plant") and 
		overlaps_body(player)
	):
		have_seedling = true
		plant.visible = true
		game_controller.subtract_seed()
