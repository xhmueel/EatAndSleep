class_name Damaging
extends Area2D

@export_file("*.tscn") var level_to_reload

@onready var anim : AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		#TODO Take damage
		reload_level()

func activate() -> void:
	#In traps it is the contrary (activate is to make them disappear)
	anim.play("appear")
	
func deactivate() -> void:
	#In traps it is the contrary (deactivate is to make them appear)
	anim.play("disappear")

func reload_level():
	print("loading level : ", level_to_reload)
	get_tree().change_scene_to_file(level_to_reload)
