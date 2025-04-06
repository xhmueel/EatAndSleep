extends Node2D

enum BUTTON_TYPE {PRESS, TOGGLE, TIMED, ONCE}

@onready var sprite : Sprite2D = $Sprite2D

@export var button_type : BUTTON_TYPE = BUTTON_TYPE.PRESS
@export var platforms : Array[Node2D] = [];
@export var traps : Array[Damaging] = [];

@export var texture : CompressedTexture2D = load("res://Assets/buttons/press_button_red.png")

var toggle_state : bool = false;

var once_used = false;

func _ready() -> void:
	sprite.texture = texture 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		match button_type:
			BUTTON_TYPE.PRESS, BUTTON_TYPE.TIMED:
				activate_objects(true)
			BUTTON_TYPE.TOGGLE:
				if toggle_state:
					activate_objects(false)
				else:
					activate_objects(true)
				toggle_state = not toggle_state
			BUTTON_TYPE.ONCE:
				#Deactivate traps
				if not once_used:
					activate_objects(true)
					once_used = not once_used


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		match button_type:
			BUTTON_TYPE.PRESS:
				activate_objects(false)
				pass

func activate_objects(activate : bool) -> void:
	for platform in platforms:
		if activate:
			platform.activate()
		else:
			platform.deactivate()
	for trap in traps:
		if activate:
			#Make traps dissapear
			trap.deactivate()
		else:
			#Make traps appear
			trap.activate()
