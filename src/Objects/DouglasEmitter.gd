extends Node2D

export var x_variance: float = 200
export var frequency: float = 5.0
export var max_num: int = 300
onready var douglas: Resource = preload("res://src/Objects/PhysicsDouglas.tscn")

var rng = RandomNumberGenerator.new()
var timer = 0
var total = 0

func _ready():
	rng.randomize()

func _process(delta):
	timer += delta
	if timer > frequency and total < max_num:
		spawn()
		total += 1
		timer -= frequency


func spawn() -> void:
	var douglas_instance: RigidBody2D = douglas.instance()
	douglas_instance.set_name("douglas")
	douglas_instance.position.x += rng.randf_range(-x_variance, x_variance)
	add_child(douglas_instance)
