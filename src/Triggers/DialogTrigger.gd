extends Area2D

export (String, FILE, "*.json") var dialoge_file_path: String

onready var dialog_controller = get_node("/root/level/UI/DialogController")
var triggered: bool = false

func _on_body_entered(body: PhysicsBody2D) -> void:
	if !triggered:
		start()
		triggered = true

func start() -> void:
	var dialog: Array = load_dialog(dialoge_file_path)
	dialog_controller.show_dialog(dialog)
	
func load_dialog(file_path) -> Array:
	var file = File.new()
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	var dialog = parse_json(file.get_as_text())
	assert dialog.size() > 0
	return dialog
