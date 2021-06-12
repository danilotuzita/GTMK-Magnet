extends Node2D

onready var player1 = $Player1
onready var player2 = $Player2
onready var winConditions = $WinConditions

export(String) var next_level = "Level1"

func _ready():
	player1.other_player = player2
	player2.other_player = player1
	
	for child in winConditions.get_children():
		child.connect("objective_complete", self, "_on_objective_complete")
	
	
func _on_objective_complete():
	for child in winConditions.get_children():
		if not child.completed:
			return
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Levels/" + next_level + ".tscn")

