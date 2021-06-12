extends Area2D

onready var collision =  $CollisionShape2D
onready var line = $Line2D
onready var audio = $AudioStreamPlayer2D

var other_body = null
export(int, -1, 1, 1) var polarity = 1 setget set_polarity
export(float) var intensity = 5
export(float, -360, 360) var start_angle = 0

func _ready():
	$Sprite.rotation_degrees = start_angle


func _physics_process(_delta):
	if other_body and polarity:
		line.visible = true
		line.points[1] = other_body.global_position - global_position
		var attraction = -1 if polarity == other_body.polarity else 1
		other_body.apply_magnetic_force(global_position, Vector2(attraction, attraction) * intensity)
		var angle = global_position.angle_to_point(other_body.global_position)
		$Sprite.rotation = angle + (PI / 2)
	else:
		line.visible = false


func _on_Magnet_body_entered(body):
	if other_body == null:
		audio.volume_db = linear2db(Configs.master_audio_volume / 15)
		other_body = body


func _on_Magnet_body_exited(body):
	if body == other_body:
		audio.volume_db = linear2db(0)
		other_body = null
		
func set_polarity(new_polarity: int):
	if new_polarity > 1 or new_polarity < -1:
		return
	polarity = new_polarity
	match polarity:
		1:
			$Sprite/ColorRect.visible = true
			$Sprite/ColorRect2.visible = true
		0:
			$Sprite/ColorRect.visible = false
			$Sprite/ColorRect2.visible = false
		-1:
			$Sprite/ColorRect.visible = true
			$Sprite/ColorRect2.visible = false
