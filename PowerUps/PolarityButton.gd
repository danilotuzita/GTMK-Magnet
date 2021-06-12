extends Area2D


func _on_Button_body_entered(body):
	print_debug("change polarity")
	body.change_polarity()
