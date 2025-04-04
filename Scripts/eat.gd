extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var sleepy_available = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("eat_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Eat
	if Input.is_action_just_pressed("eat_action"):
		pass
		
	# Movement
	var direction = Input.get_axis("eat_left", "eat_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	print("Sleepy available: ", sleepy_available)
	move_and_slide()


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Sleepy"):
		sleepy_available = true


func _on_eat_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Sleepy"):
		sleepy_available = false
