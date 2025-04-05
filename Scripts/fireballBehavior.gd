extends Damaging

@onready var parent : Node2D = $"../../.."
@onready var path: PathFollow2D = $".."
@onready var sprite: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	if parent.is_moving:
		path.progress += parent.speed * delta
		sprite.rotation += parent.rotation_speed * delta
		
#Might have a problem with the signal
