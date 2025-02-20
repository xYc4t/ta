extends CharacterBody2D

# Constants for speed and jump velocity
@export var SPEED = 150.0
@export var JUMP_VELOCITY = -400.0

# Reference to the AnimatedSprite2D node
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("mv_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction for horizontal movement
	var direction := Input.get_axis("mv_left", "mv_right")
	
	# If there's input, move the character and play the "run" animation
	if direction:
		velocity.x = direction * SPEED
		# Flip the sprite based on direction
		if direction > 0:
			animated_sprite.flip_h = false  # facing right
		else:
			animated_sprite.flip_h = true  # facing left
		# Play the "run" animation
		animated_sprite.play("run")
	else:
		# If no input, decelerate the character and play the "idle" animation
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("default")
	
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite.play("default")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

	
	# Apply the movement
	move_and_slide()
