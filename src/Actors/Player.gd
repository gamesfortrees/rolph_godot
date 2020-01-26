extends Actor

export var stomp_impulse := 1000.0

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var land_sound: AudioStreamPlayer = get_node("land_sound")
onready var jump_sound: AudioStreamPlayer = get_node("jump_sound")
onready var hit_sound: AudioStreamPlayer = get_node("hit_sound")
onready var default_face: Sprite = get_node("default")
onready var jumping_face: Sprite = get_node("jump")
onready var game_controller := get_node("/root/level/GameController")

var facing: int = 1
var current_face: Sprite = default_face

func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calculate_velocity(_velocity, direction, max_speed, is_jump_interrupted)
	var was_on_floor := is_on_floor() 
	_velocity = move_and_slide(_velocity, Vector2.UP)
	if is_on_floor() and !was_on_floor:
		land_sound.play()
	animate(_velocity.x)
	flip(_velocity.x)
	swap_face()
	
func swap_face() -> void:
	if is_on_floor():
		if current_face != default_face:
			default_face.visible = true
			jumping_face.visible = false
			current_face = default_face
	else:
		if current_face != jumping_face:
			jumping_face.visible = true
			default_face.visible = false
			current_face = jumping_face
	
func animate(x_speed: float) -> void:
	if x_speed == 0.0:
		anim_player.stop()
	else:
		anim_player.play("running")
		
func flip(x_speed: float) -> void:
	var flip := x_speed < 0.0 && facing == 1 || x_speed > 0.0 && facing == -1
	if flip:
		apply_scale(Vector2(-1, 1))
		if x_speed < 0.0:
			facing = -1
		else:
			facing = 1
		
func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	hit_sound.play()
	
func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	game_controller.player_died()

func get_direction() -> Vector2:
	var right := Input.get_action_strength("move_right")
	var left := Input.get_action_strength("move_left")
	var jump := 1.0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump = -1.0
		jump_sound.play()
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
