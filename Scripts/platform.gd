extends Node2D

@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var anim_body : AnimatableBody2D = $Path2D/PathFollow2D/AnimatableBody2D

@export var speed : int = 100;
@export var is_loop_path : bool = false;
@export var is_start_moving : bool = false;

var is_activate;

func _ready() -> void:
	path.loop = is_loop_path
	if is_start_moving:
		is_activate = true;
	else:
		is_activate = null;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_activate:
		path.progress += speed * delta
		anim_body.global_position = anim_body.global_position
	elif is_activate == false:
		path.progress -= speed * delta
		anim_body.global_position = anim_body.global_position
	

func activate() -> void:
	is_activate = true
	
func deactivate() -> void:
	is_activate = false
	
