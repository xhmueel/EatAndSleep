extends Button

@export_file("*.tscn") var level_to_load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	change_level()

func change_level():
	print("loading level : " + level_to_load)
	get_tree().paused = false
	get_tree().change_scene_to_file(level_to_load)
