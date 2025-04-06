extends TextureButton


@export_file("*.tscn") var level_to_load
@export var transition_player : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	change_level()

func change_level():
	print("loading level : " + level_to_load)
	get_tree().paused = false
	transition_player.show()
	transition_player.play("fade_out")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(level_to_load)
