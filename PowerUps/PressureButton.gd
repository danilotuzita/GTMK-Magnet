extends Area2D

onready var tween = $Tween
onready var progressBar = $StaticBody2D/CollisionShape2D/ProgressBar
var energized: bool = false

func _on_PressureButton_body_entered(_body):
	if energized: return
	tween.interpolate_property(progressBar, "modulate", Color.white, Color.yellow, 2)
	tween.interpolate_property(progressBar, "value", 0, 100, 2)
	tween.start()


func _on_PressureButton_body_exited(_body):
	if energized: return
	tween.stop_all()
	progressBar.modulate = Color.white
	progressBar.value = 0


func _on_Tween_tween_completed(_object, _key):
	print("GREAT JOB!")
	energized = true
