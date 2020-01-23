extends Actor

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -max_speed.x
	
func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	if _velocity.x < 0.0:
		get_node("enemy").set_flip_h(true)
	if _velocity.x > 0.0:
		get_node("enemy").set_flip_h(false)
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y
