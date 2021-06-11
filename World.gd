extends Node2D

onready var player1 = $Player
onready var player2 = $Player2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player1.other_player = player2
	player2.other_player = player1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
