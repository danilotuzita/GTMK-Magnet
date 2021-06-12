extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_body_entered(body):
	body.change_polarity()
	
	print("ok")
	#queue_free()
	
	pass # Replace with function body.


func _on_Button_body_shape_entered(body_id, body, body_shape, local_shaape):
	#body.polarity *= -1
	
	print("ok")
	#queue_free()
	
	pass # Replace with function body.

func _on_Button_area_shape_entered(area_id, area, area_shape, local_shape):
	#area.polarity *= -1
	
	print("ok")
	#queue_free()
