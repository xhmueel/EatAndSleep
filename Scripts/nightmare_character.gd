extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("sleep_toggle"):
		self.queue_free()
	
	# Get the input direction and handle the movement/deceleration.
	var direction : Vector2
	var input = Input.get_vector("sleep_left", "sleep_right", "sleep_up", "sleep_down")
	if input.length() != 0:
		direction = input
		
	velocity = velocity.lerp(input * SPEED, delta*3)

	move_and_slide()
