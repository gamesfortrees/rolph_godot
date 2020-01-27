extends MarginContainer

onready var text: Label = get_node("MarginContainer/MarginContainer/HBoxContainer/MarginContainer2/text")
onready var avatar: TextureRect = get_node("MarginContainer/MarginContainer/HBoxContainer/MarginContainer/avatar")

export var rolph_neutral: Texture
export var rolph_scared: Texture
export var douglas_neutral: Texture
export var douglas_angry: Texture
export var narrator: Texture

var current_dialog: Array
var current_line: int = 0

func _physics_process(delta: float) -> void:
	if !visible:
		return
	if Input.is_action_just_pressed("jump"):
		advance_dialog()

func show_dialog(dialog: Array) -> void:
	if len(dialog) == 0:
		return
	
	visible = true
	get_tree().paused = true
	current_dialog = dialog
	current_line = 0
	advance_dialog()
	
func advance_dialog() -> void:
	if current_line == len(current_dialog):
		stop_dialog()
		return
	var d: Dictionary = current_dialog[current_line]
	set_text(d["text"])
	set_avatar(d["name"], d["expression"])
	current_line += 1
	
func stop_dialog() -> void:
	visible = false
	get_tree().paused = false

func set_text(new_text: String) -> void:
	text.text = new_text
	
func set_avatar(speaker: String, expression: String="") -> void:
	match [speaker, expression]:
		["", ""]:
			avatar.texture = narrator
		["rolph", "neutral"], ["rolph", ""]:
			avatar.texture = rolph_neutral
		["rolph", "scared"]:
			avatar.texture = rolph_scared
		["douglas", "neutral"], ["douglas", ""]:
			avatar.texture = douglas_neutral
		["douglas", "angry"]:
			avatar.texture = douglas_angry
		_:
			avatar.texture = narrator