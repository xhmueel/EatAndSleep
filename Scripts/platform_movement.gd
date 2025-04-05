extends RemoteTransform2D

@onready var parent : Node2D = $"../../.."
@onready var path : PathFollow2D = $".."

@export var speed : int = 100;
@export var is_loop_path : bool = false;
@export var is_start_moving : bool = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(parent.is_activate)
	if parent.is_activate:
		path.progress += speed * delta
		#anim_body.global_position = anim_body.global_position
	elif parent.is_activate == false:
		path.progress -= speed * delta
		#anim_body.global_position = anim_body.global_position
	
#func activate() -> void:
	#parent.is_activate = true
	
#func deactivate() -> void:
	#parent.is_activate = false
	
