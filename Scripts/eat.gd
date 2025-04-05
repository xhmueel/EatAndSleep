extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

const SPIT_SPEED_X = 600.0
const SPIT_SPEED_Y = -350.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var eat_area_shape: CollisionShape2D

@onready var animated_sprite = $AnimatedSprite2D

var sleepy_available = false
var sleepy_ref: Sleepy = null
var sleepy_eaten = false

var facing = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eat_area_shape = get_node("EatArea/CollisionShape2D")


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
		# Swallow sleepy
		if not sleepy_eaten:
			if sleepy_available and sleepy_ref and sleepy_ref.is_sleeping:
				sleepy_ref.process_mode = Node.PROCESS_MODE_DISABLED
				sleepy_eaten = true
				sleepy_ref.visible = false
		# Spit sleepy
		elif sleepy_eaten:
			sleepy_ref.process_mode = Node.PROCESS_MODE_INHERIT
			sleepy_eaten = false
			sleepy_ref.position = self.position
			sleepy_ref.position.y -= 1
			sleepy_ref.velocity = Vector2(SPIT_SPEED_X * facing, SPIT_SPEED_Y)
			sleepy_ref.got_spit = true
			sleepy_ref.visible = true
		
	# Movement
	var direction = Input.get_axis("eat_left", "eat_right")
	var previous_facing = facing
	if direction:
		velocity.x = direction * SPEED
		facing = 1 if direction > 0 else -1
		animated_sprite.play("walk")
		animated_sprite.flip_h = false if direction > 0 else 1
	else:
		animated_sprite.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if facing != previous_facing:
		eat_area_shape.position.x *= -1
	
	move_and_slide()


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Sleepy"):
		sleepy_available = true
		sleepy_ref = body as Sleepy
		


func _on_eat_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Sleepy"):
		sleepy_available = false
