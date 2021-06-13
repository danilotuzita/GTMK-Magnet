extends Area2D

onready var collision = $MagneticRange
onready var hint = $MagneticRange/Hint
onready var lines = [$Line2D, $Line2D2]
onready var audio = $AudioStreamPlayer2D

var other_bodys: Array = []
export(int, -1, 1, 1) var polarity = 1 setget set_polarity
export(float) var intensity = 5
export(float, -360, 360) var start_angle = 0
export var alpha = .3
var color_positive = Color("cc4b54")
var color_negative = Color("67a9db")

func _ready():
	color_positive.a = alpha
	color_negative.a = alpha
	set_polarity(polarity)
	$Sprite.rotation_degrees = start_angle
	$Line2D.width = 5 * intensity
	$Line2D2.width = 5 * intensity


func _physics_process(_delta):
	var i = 0
	for line in lines:
		var other_body = null
		if i < other_bodys.size():
			other_body = other_bodys[i]
		i += 1
		if other_body and polarity:
			line.visible = true
			line.points[1] = other_body.global_position - global_position
			var attraction = -1 if polarity == other_body.polarity else 1
			other_body.apply_magnetic_force(global_position, Vector2(attraction, attraction) * intensity)
			var angle = global_position.angle_to_point(other_body.global_position)
			$Sprite.rotation = angle - (PI / 2)
		else:
			line.visible = false


func _on_Magnet_body_entered(body):
	other_bodys.append(body)
	if other_bodys.size() == 1:
		audio.volume_db = linear2db(Configs.master_audio_volume / 20)


func _on_Magnet_body_exited(body):
	other_bodys.erase(body)
	if other_bodys.size() == 0:
		audio.volume_db = linear2db(0)


func set_polarity(new_polarity: int):
	if new_polarity > 1 or new_polarity < -1:
		return
	polarity = new_polarity
	match polarity:
		1:
			$Sprite/Plus.visible = true
			$Sprite/Minus.visible = false
			if hint:
				hint.modulate = color_positive
		0:
			$Sprite/Plus.visible = false
			$Sprite/Minus.visible = false
		-1:
			$Sprite/Plus.visible = false
			$Sprite/Minus.visible = true
			if hint:
				hint.modulate = color_negative
