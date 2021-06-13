extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
export var JUMP_SPEED = 250


onready var audio = $AudioStreamPlayer
onready var audio_tracks = [preload("res://Sounds/polarize-negative.ogg"), preload("res://Sounds/polarize-positive.ogg"), preload("res://Sounds/teleportation.ogg")]
onready var steps = $AudioSteps
onready var steps_tracks = [preload("res://Sounds/step-1.ogg"), preload("res://Sounds/step-2.ogg"), preload("res://Sounds/jump.ogg")]
onready var sprite = $AnimatedSprite
onready var panel_sprite = $AnimatedSprite2
onready var light = $LightFat

var velocity: Vector2 = Vector2.ZERO
var magnetic_force: Vector2 = Vector2.ZERO # all magnetic force applied to body
var other_player
var step_count = 0
var teleported = false

export(String, "fat", "slim") var robot = "fat"
export(int, -1, 1, 1) var polarity = 1 setget set_polarity
export var color_positive = Color("cc4b54")
export var color_negative = Color("67a9db")
export var can_fly = false

signal teleported()

func _ready():
	sprite.animation = robot + "-walk"
	if robot == "slim":
		$LightFat.visible = false
		light = $LightSlim
		light.visible = true
	update_color()


func _physics_process(delta: float):
	var x = 1 if sprite.flip_h else -1
	var y = 1 if sprite.flip_v else -1
	light.position = Vector2(x * abs(light.position.x), y * abs(light.position.y))
	# light.rotation = x * light.rotation
	
	$Line2D.points[1] = other_player.position - position
	$Line2D2.points[1] = velocity #magnetic_force * 10
	
	magnetic_force = Vector2.ZERO
	apply_movement(delta)
	
	#Magnetic movement
	var attraction = -1 if polarity == other_player.polarity else 1
	apply_magnetic_force(other_player.global_position, Vector2(15, attraction) * 5)
	

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	# Check for jumping. is_on_floor() must be called after movement code.
	var jump_direction = 0
	if can_fly:
		jump_direction = 1 if magnetic_force.y > 0 else -1
	else:
		jump_direction = int(is_on_floor()) - int(is_on_ceiling())
	if jump_direction and Input.is_action_just_pressed("jump"):
		velocity.y += -JUMP_SPEED * jump_direction
		steps.volume_db = linear2db(Configs.master_audio_volume / 20)
		steps.stream = steps_tracks[2]
		steps.play()
	


func set_polarity(value):
	polarity = value
	update_color()


func change_polarity():
	self.polarity *= -1
	if polarity == 0:
		return
	var track_num = int(polarity > 0)
	audio.volume_db = linear2db(Configs.master_audio_volume / 15)
	audio.stream = audio_tracks[track_num]
	audio.play()
	

func update_color():
	var new_color = Color.white
	var new_anim = robot + "-positive"
	match polarity:
		1:
			new_color = color_positive
		-1:
			new_color = color_negative
			new_anim = robot + "-negative"
	if sprite:
		sprite.modulate = new_color
	if panel_sprite:
		var last_frame = panel_sprite.frame
		panel_sprite.animation = new_anim
		panel_sprite.frame = last_frame
	if $Line2D:
		$Line2D.default_color = new_color


func apply_movement(delta: float):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		sprite.playing = false
		sprite.frame = 2
		panel_sprite.playing = false
		panel_sprite.frame = 2
	else:
		velocity.x += walk * delta
		sprite.flip_h = walk < 0
		sprite.playing = true
		panel_sprite.flip_h = walk < 0
		panel_sprite.playing = true
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)


func apply_magnetic_force(origin: Vector2, weight: Vector2 = Vector2(1, 1)):
	var magnetic_vector = (origin - global_position).normalized()
	magnetic_vector *= weight
	velocity += magnetic_vector
	magnetic_force += magnetic_vector
	if magnetic_force.y > 0:
		sprite.flip_v = false
		panel_sprite.flip_v = false
	else:
		sprite.flip_v = true
		panel_sprite.flip_v = true
	return magnetic_vector


func _on_AnimatedSprite_frame_changed():
	if not (is_on_floor() or is_on_ceiling()):
		steps.volume_db = linear2db(Configs.master_audio_volume / 20)
		return
	match sprite.frame:
		1, 6:
			steps.volume_db = linear2db(Configs.master_audio_volume / 20)
			steps.stream = steps_tracks[step_count % 2]
			steps.play()
			step_count += 1

func teleport_animation(direction = 1):
	if direction == 1:
		$Tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ZERO, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	audio.stream = audio_tracks[2]
	audio.volume_db = linear2db(Configs.master_audio_volume / 10)
	$Tween.start()
	audio.play()


func _on_Tween_tween_completed(_object, _key):
	teleported = true
	emit_signal("teleported")
