class_name Shadow extends CharacterBody2D

const SPEED = 220.0
const ACCEL = 2000.0
const JUMP_VELOCITY = -500.0
const SPIT_FRICTION = 10.0
const GROUND_FRICTION = 12000.0
const AIR_FRICTION = 4000.0
const COYOTE_TIME = 0.2
const JUMP_BUFFER_TIME = 0.2
const JUMP_COOLDOWN = COYOTE_TIME + 0.2

const SLEEP_OFFSET_Y = 42.0

var nightmare_character_scene = preload("res://Scenes/nightmare_character.tscn")

var is_sleeping = false
var got_spit = false
var was_grounded = true
var last_ground_time = 0.0
var last_jump_input_time = JUMP_BUFFER_TIME + 1
var last_jumped_time = JUMP_COOLDOWN + 1

@onready var collision_shape = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D

var can_fly = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("sleep_toggle"):
		self.queue_free()
	
	if can_fly:
		process_fly_movement(delta)
	else:
		process_ground_movement(delta)

	move_and_slide()

func process_fly_movement(delta : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	animated_sprite.play("idle")
	var direction : Vector2
	var input = Input.get_vector("sleep_left", "sleep_right", "sleep_up", "sleep_down")
	if input.length() != 0:
		direction = input
	animated_sprite.flip_h = true if direction.x < 0 else false
		
	velocity = velocity.lerp(input * SPEED, delta*3)

func process_ground_movement(delta : float) -> void:
	print("is on floor", is_on_floor())
	print("was_grounded ", was_grounded)
	if (is_on_floor() and not was_grounded
	and (animated_sprite.animation != "wake" or animated_sprite.frame == 8)):
		print("bitch")
		animated_sprite.play("land")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("sleep_left", "sleep_right")
	var temp_v = Vector2(direction, 0)
	if direction:
		velocity.x = move_toward(velocity.x, temp_v.x * SPEED, ACCEL * delta)
		animated_sprite.flip_h = true if direction < 0 else false
		if (is_on_floor() and
		animated_sprite.animation not in ["land", "wake"]
		or (animated_sprite.animation == "land" and animated_sprite.frame == 1)
		or (animated_sprite.animation == "wake" and animated_sprite.frame == 8)):
			animated_sprite.play("walk")
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, temp_v.x, AIR_FRICTION * delta)
		else:		
			velocity.x = move_toward(velocity.x, temp_v.x, GROUND_FRICTION * delta)
			if (animated_sprite.animation not in ["land", "wake"]
			or (animated_sprite.animation == "land" and animated_sprite.frame == 1)
			or (animated_sprite.animation == "wake" and animated_sprite.frame == 8)):
				animated_sprite.play("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("sleep_up"):
		last_jump_input_time = 0
		
	if (last_jumped_time > JUMP_COOLDOWN
	and last_jump_input_time < JUMP_BUFFER_TIME
	and last_ground_time < COYOTE_TIME):
		animated_sprite.play("jump")
		velocity.y = JUMP_VELOCITY
		last_jumped_time = 0.0
		last_jump_input_time = JUMP_BUFFER_TIME + 1
		last_ground_time = COYOTE_TIME + 1
		
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			animated_sprite.play("fall")
		velocity += get_gravity() * delta
		
	last_ground_time += delta
	last_jumped_time += delta
	last_jump_input_time += delta
		
	if is_on_floor():
		was_grounded = true
		last_ground_time = 0
	else:
		was_grounded = false
