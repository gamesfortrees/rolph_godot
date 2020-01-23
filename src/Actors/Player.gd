extends Actor

export var stomp_impulse := 1000.0

func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calculate_velocity(_velocity, direction, max_speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, Vector2.UP)
	if _velocity.x < 0.0:
		get_node("player").set_flip_h(true)
	if _velocity.x > 0.0:
		get_node("player").set_flip_h(false)
		
func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	
func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	queue_free()

func get_direction() -> Vector2:
	var right := Input.get_action_strength("move_right")
	var left := Input.get_action_strength("move_left")
	var jump := 1.0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump = -1.0
	return Vector2(right - left, jump)
	
func calculate_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interruped: bool
	) -> Vector2:
	var new_velocity := linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interruped:
		new_velocity.y = 0
	return new_velocity
	
func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var new_velocity := linear_velocity
	new_velocity.y = -impulse
	return new_velocity
