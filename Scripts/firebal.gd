extends Node2D

@export var is_moving : bool = true;
@export var speed : int = 100;
@export var rotation_speed : int = 1;

@export var is_blinking : bool = false;
@export var blink_offset : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
