class_name Damaging
extends Area2D

@onready var anim : AnimationPlayer = $"../AnimationPlayer"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Group"):
		#TODO Take damage
		body.Die()

func activate() -> void:
	#In traps it is the contrary (activate is to make them disappear)
	anim.play("appear")
	
func deactivate() -> void:
	#In traps it is the contrary (deactivate is to make them appear)
	anim.play("dissapear")
