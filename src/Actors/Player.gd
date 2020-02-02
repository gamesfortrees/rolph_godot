extends Actor

export var stomp_impulse := 1000.0

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var land_sound: AudioStreamPlayer = get_node("land_sound")
onready var jump_sound: AudioStreamPlayer = get_node("jump_sound")
onready var hit_sound: AudioStreamPlayer = get_node("hit_sound")
onready var game_controller := get_node("/root/GameController")
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var legs_node: Node = get_node("Legs")

const MOVE_FORCE = 100
const MAX_SPEED = 700
const JUMP_HEIGHT = 1200
const FRICTION_FACTOR_GROUND = 0.2
const FRICTION_FACTOR_AIR = 0.05

func _physics_process(delta: float) -> void:
	var friction_factor = FRICTION_FACTOR_GROUND
	
	_velocity.y += gravity
	
	var right := Input.get_action_strength("move_right")
	var left := Input.get_action_strength("move_left")
	
	if right > 0:
		_velocity.x += MOVE_FORCE
		animated_sprite.flip_h = false
		legs_node.scale = Vector2(1,1)
		animated_sprite.play("default")
	elif left > 0:
		_velocity.x -= MOVE_FORCE
		animated_sprite.flip_h = true
		legs_node.scale = Vector2(-1,1)
		animated_sprite.play("default")
	else:
		_velocity.x = 0
		friction_factor = FRICTION_FACTOR_AIR
		animated_sprite.play("scared")
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_velocity.y = -JUMP_HEIGHT
		jump_sound.play()
	
	if not is_on_floor() and _velocity.y < 0:
		animated_sprite.play("jump")
	
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	if is_jump_interrupted:
		_velocity.y = 0
	
	# Apply friction
	_velocity.x = lerp(_velocity.x, 0, friction_factor)
	_velocity.x = clamp(_velocity.x, -MAX_SPEED, MAX_SPEED)
	
	animate(_velocity.x) # animate legs
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
func animate(x_speed: float) -> void:
	if x_speed == 0.0:
		anim_player.stop()
	else:
		anim_player.play("running")
		
func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	hit_sound.play()
	
func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	game_controller.player_died()
	
func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var new_velocity := linear_velocity
	new_velocity.y = -impulse
	return new_velocity
