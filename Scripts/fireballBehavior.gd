extends Damaging

@onready var parent : Node2D = $"../../.."
@onready var path: PathFollow2D = $".."
@onready var sprite: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	if parent.is_moving:
		path.progress += parent.speed * delta
		sprite.rotation += parent.rotation_speed * delta
	
		#if sprite.modulate.a < 0.1:
		#	monitoring = false;
		#elif sprite.modulate.a > 0.1:
		#	monitoring = true;
			
#Might have a problem with the signal

func activate() -> void:
	#sprite.modulate.a = lerp(sprite.modulate.a, 0, parent.activate_speed)
	anim.play("appear")
	
func deactivate() -> void:
	#sprite.modulate.a = lerp(sprite.modulate.a, 1, parent.activate_speed)
	anim.play("disappear")
