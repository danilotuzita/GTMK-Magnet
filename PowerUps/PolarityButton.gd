extends Area2D

onready var tween = $Tween
onready var spin_sprite = $Sprite

func _ready():
	tween.interpolate_property(spin_sprite, "rotation", 0, 2 * PI, 2)
	tween.repeat = true
	tween.start()


func _on_Button_body_entered(body):
	body.change_polarity()
	modulate = Color(1, 1, 1, .2)


func _on_Button_body_exited(_body):
	modulate = Color(1, 1, 1, 1)
