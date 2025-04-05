class_name Sleepy extends CharacterBody2D

const SPEED = 220.0
const ACCEL = 2000.0
const JUMP_VELOCITY = -300.0
const SPIT_FRICTION = 10.0
const GROUND_FRICTION = 12000.0
const AIR_FRICTION = 4000.0

const SLEEP_OFFSET_Y = 42.0

var nightmare_character_scene = preload("res://Scenes/nightmare_character.tscn")

var is_sleeping = false
var got_spit = false
var was_grounded = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_sleeping:
		process_sleeping(delta)
	elif not is_sleeping:
		process_awake(delta)

	move_and_slide()

func process_sleeping(delta : float) -> void:
	if Input.is_action_just_pressed("sleep_toggle"):
		animated_sprite.position.y -= SLEEP_OFFSET_Y
		is_sleeping = false
		
	if not animated_sprite.is_playing():
		animated_sprite.play("sleeping")

	if not is_on_floor():
		velocity += get_gravity() * delta

	if got_spit:
		velocity.x = move_toward(velocity.x, 0, SPIT_FRICTION)
		# End spit physics once you stop
		if velocity.length_squared() < 0.01:
			got_spit = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
func process_awake(delta : float) -> void:
	if is_on_floor() and not was_grounded:
		animated_sprite.play("land")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("sleep_left", "sleep_right")
	var temp_v = Vector2(direction, 0)
	if direction:
		velocity.x = move_toward(velocity.x, temp_v.x * SPEED, ACCEL * delta)
		animated_sprite.flip_h = true if direction < 0 else false
		if is_on_floor() and (animated_sprite.animation != "land" or not animated_sprite.is_playing()):
			animated_sprite.play("walk")
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, temp_v.x, AIR_FRICTION * delta)
		else:		
			velocity.x = move_toward(velocity.x, temp_v.x, GROUND_FRICTION * delta)
			if not animated_sprite.animation == "land" or not animated_sprite.is_playing():
				animated_sprite.play("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("sleep_up") and is_on_floor():
		animated_sprite.play("jump")
		velocity.y = JUMP_VELOCITY
		
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			animated_sprite.play("fall")
		velocity += get_gravity() * delta
		
	if is_on_floor():
		was_grounded = true
	else:
		was_grounded = false
	
	if Input.is_action_just_pressed("sleep_toggle"):
		is_sleeping = true
		animated_sprite.play("falling_asleep")
		animated_sprite.position.y += SLEEP_OFFSET_Y
		velocity = Vector2(0, 0)
		spawn_nightmare()

func spawn_nightmare() -> void:
	var nightmare_character = nightmare_character_scene.instantiate()
	nightmare_character.global_position = self.global_position
	get_tree().root.add_child(nightmare_character)
	
