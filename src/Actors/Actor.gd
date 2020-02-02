extends KinematicBody2D

class_name Actor

export var max_speed := Vector2(300.0, 1000.0)
export var gravity := 50.0 
var _velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	pass
