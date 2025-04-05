extends Area2D

@export_file("*.tscn") var level_to_load

var num_players_in_zone : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_level():
	print("loading level : " + level_to_load)
	get_tree().change_scene_to_file(level_to_load)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		num_players_in_zone += 1
	if num_players_in_zone == 2:
		change_level()
	print("entered: " + str(num_players_in_zone))

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		num_players_in_zone -= 1
	print("exited: " + str(num_players_in_zone))
