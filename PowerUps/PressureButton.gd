extends Area2D

onready var tween = $Tween
onready var tween2 = $Tween2
onready var progressBar = $StaticBody2D/CollisionShape2D/ProgressBar
onready var audio = $AudioStreamPlayer2D
var completed: bool = false
var pressed: bool = false setget set_pressed
export(float, 0, 5) var timeout = 2

signal pressed()
signal released()
signal objective_complete()

func _ready():
	$SpriteMonitor.rotation = -rotation


func set_pressed(value: bool):
	pressed = value
	if pressed:
		emit_signal("pressed")
	else:
		emit_signal("released")


func start_powering():
	# tween.interpolate_property(progressBar, "modulate", Color.white, Color.yellow, timeout)
	tween.interpolate_property(progressBar, "value", 0, 100, timeout)
	tween.start()
	audio.volume_db = linear2db(Configs.master_audio_volume / 15)
	audio.play()


func stop_powering():
	tween.stop_all()
	audio.stop()
	progressBar.modulate = Color.white
	progressBar.value = 0


func start_flashing_monitor():
	tween2.interpolate_property($Light2D, "energy", .6, 1.33, .5)
	tween2.repeat = true
	tween2.start()
	
	
func stop_flashing_monitor():
	tween2.stop_all()

func _on_PressureButton_body_entered(body):
	body.light.energy += .5
	self.pressed = true


func _on_PressureButton_body_exited(body):
	body.light.energy -= .5
	self.pressed = false


func _on_Tween_tween_completed(_object, _key):
	completed = true
	emit_signal("objective_complete")
