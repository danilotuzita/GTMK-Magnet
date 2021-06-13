extends Area2D


signal spiked()

func _ready():
	pass # Replace with function body.


func _on_Spikes_body_entered(_body):
	emit_signal("spiked")
