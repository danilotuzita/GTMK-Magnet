extends Area2D

onready var tween = $Tween
onready var progressBar = $StaticBody2D/CollisionShape2D/ProgressBar
onready var audio = $AudioStreamPlayer2D
var completed: bool = false

signal objective_complete()

func _on_PressureButton_body_entered(_body):
	if completed: return
	tween.interpolate_property(progressBar, "modulate", Color.white, Color.yellow, 2)
	tween.interpolate_property(progressBar, "value", 0, 100, 2)
	tween.start()
	audio.volume_db = linear2db(Configs.master_audio_volume / 15)
	audio.play()


func _on_PressureButton_body_exited(_body):
	if completed: return
	tween.stop_all()
	audio.stop()
	progressBar.modulate = Color.white
	progressBar.value = 0


func _on_Tween_tween_completed(_object, _key):
	completed = true
	emit_signal("objective_complete")
