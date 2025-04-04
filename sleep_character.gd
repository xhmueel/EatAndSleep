extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var nightmare_character_scene = preload("res://nightmare_character.tscn")

var is_sleeping = false

func _physics_process(delta: float) -> void:
	if is_sleeping:
		process_sleeping(delta)
	elif not is_sleeping:
		process_awake(delta)

	move_and_slide()

func process_sleeping(delta : float) -> void:
	if Input.is_action_just_pressed("sleep_toggle"):
		is_sleeping = false

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
func process_awake(delta : float) -> void:
	if Input.is_action_just_pressed("sleep_toggle"):
		is_sleeping = true
		velocity = Vector2(0, 0)
		spawn_nightmare()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("sleep_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("sleep_left", "sleep_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func spawn_nightmare() -> void:
	var nightmare_character = nightmare_character_scene.instantiate()
	self.add_child(nightmare_character)
	
