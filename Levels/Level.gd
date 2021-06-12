extends Node2D

onready var player1 = $Player1
onready var player2 = $Player2

export(String) var next_level = "LevelBase"

func _ready():
	player1.other_player = player2
	player2.other_player = player1
	next_level = "res://Levels/" + next_level + ".tscn"
