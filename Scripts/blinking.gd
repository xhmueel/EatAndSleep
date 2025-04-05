extends Node2D

@onready var parent : Node2D = $"../../../.."
@onready var sprite : Sprite2D = $"../Sprite2D"
@onready var area : Damaging = $".."

var elapsed_time

func _ready() -> void:
	elapsed_time = parent.blink_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	if parent.is_blinking:
		sprite.modulate.a = lerp(0, 1, 0.5 + sin(elapsed_time))
		if sprite.modulate.a < 0.1:
			area.monitoring = false;
		elif sprite.modulate.a > 0.1:
			area.monitoring = true;
		print(area.monitoring)
