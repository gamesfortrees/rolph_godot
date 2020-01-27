extends Actor

func _ready() -> void:
	_velocity.x = max_speed.x

func _physics_process(delta: float) -> void:
	move_and_slide(_velocity, Vector2.UP)