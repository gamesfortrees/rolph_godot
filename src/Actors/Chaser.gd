extends Actor

export var stop_time: float = 2.0
var stopped := false

func _ready() -> void:
	_velocity.x = max_speed.x

func _physics_process(delta: float) -> void:
	if stopped:
		return
	move_and_slide(_velocity, Vector2.UP)
	
func stop() -> void:
	stopped = true
	yield(get_tree().create_timer(stop_time), "timeout")
	stopped = false
