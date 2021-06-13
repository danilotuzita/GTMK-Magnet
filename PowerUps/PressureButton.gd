extends Area2D

onready var tween = $Tween
onready var progressBar = $StaticBody2D/CollisionShape2D/ProgressBar
onready var audio = $AudioStreamPlayer2D
var completed: bool = false
var pressed: bool = false setget set_pressed
export(float, 0, 5) var timeout = 2

signal pressed()
signal released()
signal objective_complete()

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


func _on_PressureButton_body_entered(_body):
	self.pressed = true


func _on_PressureButton_body_exited(_body):
	self.pressed = false


func _on_Tween_tween_completed(_object, _key):
	completed = true
	emit_signal("objective_complete")
