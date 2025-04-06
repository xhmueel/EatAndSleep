extends Control

@export_file("*.tscn") var level_to_load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MarginContainer/Restart").level_to_load = level_to_load

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if self.visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true
