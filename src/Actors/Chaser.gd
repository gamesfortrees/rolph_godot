extends Actor

onready var game_controller := get_node("/root/GameController")

export var stop_time: float = 2.0
var stopped := false

func _ready() -> void:
	var speed := max_speed.x
	if game_controller.difficult:
		speed *= 1.2
	_velocity.x = speed

func _physics_process(delta: float) -> void:
	if stopped:
		return
	move_and_slide(_velocity, Vector2.UP)
	
func stop() -> void:
	stopped = true
	var adjusted_time := stop_time
	if game_controller.difficult:
		adjusted_time *= 0.8
	yield(get_tree().create_timer(adjusted_time), "timeout")
	stopped = false
