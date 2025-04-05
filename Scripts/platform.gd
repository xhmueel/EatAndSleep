extends Node2D

@onready var path : PathFollow2D = $Path2D/PathFollow2D

@export var speed : int = 100;

var is_activate = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_activate:
		path.progress += speed * delta
	else:
		path.progress -= speed * delta


func activate() -> void:
	is_activate = true
	
func deactivate() -> void:
	is_activate = false
	
