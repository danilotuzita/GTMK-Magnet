extends Area2D

onready var tween = $Tween
onready var tween2 = $Tween2
onready var progressBar = $StaticBody2D/CollisionShape2D/ProgressBar
onready var audio = $AudioStreamPlayer2D
var completed: bool = false
var pressed: bool = false setget set_pressed
var flashing = [.6, 1.33]

export(float, 0, 5) var timeout_to_complete = 2

signal pressed()
signal released()
signal objective_complete()

func _ready():
	$SpriteMonitor.rotation = -rotation
	progressBar.rect_scale = Vector2(-1 if rotation < 0 else 1, 1)
	start_flashing_monitor()

func set_pressed(value: bool):
	pressed = value
	if pressed:
		emit_signal("pressed")
	else:
		emit_signal("released")

# ENERGY FILL
# start filling
func start_powering(rate):
	if completed: return
	var curr_value = progressBar.value
	var target_value = progressBar.max_value * rate
	
	var is_filling = true if curr_value < target_value else false
	var timeout = timeout_to_complete
	if not is_filling:
		 timeout *= (curr_value / progressBar.max_value)
	
	tween.stop_all()
	tween.interpolate_property(progressBar, "value", curr_value, target_value, timeout)
	tween.start()
	
	audio.volume_db = linear2db(Configs.master_audio_volume / (15 if is_filling else 25))
	audio.pitch_scale = 1.0 if is_filling else 0.5
	audio.stop()
	audio.seek(0)
	audio.play()

# ended filling
func _on_Tween_tween_completed(_object, _key):
	audio.stop()

func stop_powering(rate):
	tween.stop_all()
	audio.stop()
	progressBar.modulate = Color.white
	progressBar.value = progressBar.max_value * rate


# MONITOR
# loop forward
func start_flashing_monitor():
	tween2.interpolate_property($Light2D, "energy", flashing[0], flashing[1], 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween2.start()

# loop backwards
func _on_Tween2_tween_completed(_object, _key):
	flashing.invert()
	start_flashing_monitor()

func stop_flashing_monitor():
	tween2.stop_all()


# SIGNALS
func _on_PressureButton_body_entered(body):
	body.light.energy += .5
	self.pressed = true


func _on_PressureButton_body_exited(body):
	body.light.energy -= .5
	self.pressed = false


func _on_ProgressBar_value_changed(value):
	if value == progressBar.max_value:
		completed = true
		emit_signal("objective_complete")
