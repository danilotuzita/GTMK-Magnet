extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 50

var velocity: Vector2 = Vector2.ZERO
var magnetic_force: Vector2 = Vector2.ZERO # all magnetic force applied to body
var other_player
export(int, -1, 1, 1) var polarity = 1


func _physics_process(delta: float):
	magnetic_force = Vector2.ZERO
	apply_movement(delta)
	
	#Magnetic movement
	var attraction = -1 if polarity == other_player.polarity else 1
	var magnetic_vector = apply_magnetic_force(other_player.global_position, Vector2(10, attraction) * 5)
	
	$Line2D.points[1] = velocity
	$Line2D2.points[1] = magnetic_force * 10

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	# Check for jumping. is_on_floor() must be called after movement code.
	if (is_on_floor() or is_on_ceiling()) and Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_SPEED * magnetic_force.y


func change_polarity():
	polarity *= -1
	# other_player.polarity *= -1


func apply_movement(delta: float):
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


func apply_magnetic_force(origin: Vector2, weight: Vector2 = Vector2(1, 1)):
	var magnetic_vector = (origin - global_position).normalized()
	magnetic_vector *= weight
	velocity += magnetic_vector
	magnetic_force += magnetic_vector
	# return magnetic_vector
