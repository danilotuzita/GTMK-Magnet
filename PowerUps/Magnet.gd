extends Area2D

onready var collision =  $CollisionShape2D

onready var line = $Line2D

var other_body = null
export(int, -1, 1, 1) var polarity = 1 setget set_polarity
export var intensity = 5


func _physics_process(_delta):
	if other_body and polarity:
		line.visible = true
		line.points[1] = other_body.global_position - global_position
		var attraction = -1 if polarity == other_body.polarity else 1
		other_body.apply_magnetic_force(global_position, Vector2(attraction, attraction) * intensity)
		var angle = global_position.angle_to_point(other_body.global_position)
		$Sprite.rotation = angle
	else:
		line.visible = false


func _on_Magnet_body_entered(body):
	if other_body == null:
		other_body = body


func _on_Magnet_body_exited(body):
	if body == other_body:
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
