extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 10

var velocity = Vector2()
var other_player

var polarity = -1

#nready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	#velocity.y += gravity * delta
	
	#Magnetic movement
	
	
	#var magnetic_vector = position.move_toward(other_player.position,1)
	var magnetic_vector =  other_player.position - position
	
	magnetic_vector.y *= polarity 
	
	velocity += magnetic_vector*0.1
	
	$Line2D.points[1] = velocity
	$Line2D2.points[1] = magnetic_vector

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	$Label.text = String(velocity)
	
	# Check for jumping. is_on_floor() must be called after movement code.
	if (is_on_floor() or is_on_ceiling()) and Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_SPEED*magnetic_vector.y
		
