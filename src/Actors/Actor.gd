extends KinematicBody2D

class_name Actor

export var max_speed := Vector2(600.0, 1300.0)
export var gravity := 3600.0 
var _velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	pass
