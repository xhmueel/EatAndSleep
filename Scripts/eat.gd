extends CharacterBody2D

const SPEED = 280.0
const ACCEL = 2500.0
const JUMP_VELOCITY = -500.0
const FRICTION = 3000.0
const COYOTE_TIME = 0.2
const JUMP_BUFFER_TIME = 0.2
const JUMP_COOLDOWN = COYOTE_TIME + 0.2

const EAT_STARTUP = 0.25

const SPIT_SPEED_X = 1000.0
const SPIT_SPEED_Y = -350.0
const SPIT_OFFSET_X = 50.0
const SPIT_OFFSET_Y = -80.0

const PRIORITY_ANIMS = ["land", "eat", "spit", "land_full"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var eat_area_shape: CollisionShape2D

@onready var animated_sprite = $AnimatedSprite2D

var sleepy_available = false
var sleepy_ref: Sleepy = null
var sleepy_eaten = false
var eat_time = 0.0
var is_eating = false

var was_grounded = true
var last_ground_time = 0.0
var last_jump_input_time = JUMP_BUFFER_TIME + 1
var last_jumped_time = JUMP_COOLDOWN + 1

var facing = 1

var append_full = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eat_area_shape = get_node("EatArea/CollisionShape2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_on_floor() and not was_grounded:
		animated_sprite.play("land"+append_full)
		
	# Eat
	if Input.is_action_just_pressed("eat_action") and not is_eating:
		# Swallow sleepy
		if not sleepy_eaten:
			animated_sprite.play("eat")
			eat_time = 0.0
			is_eating = true
		# Spit sleepy
		elif sleepy_eaten:
			animated_sprite.play("spit")
			$LaunchAudio.play()
			append_full = ""
			sleepy_ref.process_mode = Node.PROCESS_MODE_INHERIT
			sleepy_eaten = false
			sleepy_ref.position = self.position
			sleepy_ref.position.x += SPIT_OFFSET_X * facing
			sleepy_ref.position.y += SPIT_OFFSET_Y
			sleepy_ref.velocity = Vector2(SPIT_SPEED_X * facing, SPIT_SPEED_Y)
			sleepy_ref.got_spit = true
			sleepy_ref.visible = true
	eat_time += delta
	if eat_time > EAT_STARTUP and is_eating:
		is_eating = false
		if sleepy_available and sleepy_ref and sleepy_ref.is_sleeping:
			$EatAudio.play()
			append_full = "_full"
			sleepy_ref.process_mode = Node.PROCESS_MODE_DISABLED
			sleepy_eaten = true
			sleepy_ref.visible = false
		
	# Movement
	var direction = Input.get_axis("eat_left", "eat_right")
	var previous_facing = facing
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		facing = 1 if direction > 0 else -1
		animated_sprite.flip_h = false if direction > 0 else 1
		if (is_on_floor() and 
		(animated_sprite.animation not in PRIORITY_ANIMS or not animated_sprite.is_playing())):
			animated_sprite.play("walk"+append_full)
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, direction, FRICTION * delta)
		else:		
			velocity.x = move_toward(velocity.x, direction, FRICTION * delta)
			if animated_sprite.animation not in PRIORITY_ANIMS or not animated_sprite.is_playing():
				animated_sprite.play("idle"+append_full)
	
	if facing != previous_facing:
		eat_area_shape.position.x *= -1
		
	# Handle jump.
	if Input.is_action_just_pressed("eat_up"):
		last_jump_input_time = 0
		
	if (last_jumped_time > JUMP_COOLDOWN
	and last_jump_input_time < JUMP_BUFFER_TIME
	and last_ground_time < COYOTE_TIME):
		animated_sprite.play("jump"+append_full)
		velocity.y = JUMP_VELOCITY
		last_jumped_time = 0.0
		last_jump_input_time = JUMP_BUFFER_TIME + 1
		last_ground_time = COYOTE_TIME + 1
		
	# Gravity
	if not is_on_floor():
		if velocity.y > 0 and animated_sprite.animation != "fall"+append_full:
			animated_sprite.play("fall"+append_full)
		velocity.y += gravity * delta
	
	last_ground_time += delta
	last_jumped_time += delta
	last_jump_input_time += delta
	if is_on_floor():
		was_grounded = true
		last_ground_time = 0.0
	else:
		was_grounded = false
	
	move_and_slide()


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Sleepy"):
		sleepy_available = true
		sleepy_ref = body as Sleepy
		


func _on_eat_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Sleepy"):
		sleepy_available = false
