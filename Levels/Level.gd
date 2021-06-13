extends Node2D

onready var player1 = $Player1
onready var player2 = $Player2
onready var winConditions = $WinConditions

var start_pos1: Vector2
var start_polarity1: int
var start_pos2: Vector2
var start_polarity2: int

export(String) var next_level = "LevelTest"


func _ready():
	player1.connect("teleported", self, "_on_objective_complete2")
	player1.other_player = player2
	start_pos1 = player1.global_position
	start_polarity1 = player1.polarity
	
	player2.connect("teleported", self, "_on_objective_complete2")
	player2.other_player = player1
	start_pos2 = player2.global_position
	start_polarity2 = player2.polarity
	
	
	for child in winConditions.get_children():
		child.connect("pressed", self, "_on_pressed")
		child.connect("released", self, "_on_released")
		child.connect("objective_complete", self, "_on_objective_complete")
	

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		player1.global_position = start_pos1
		player1.polarity = start_polarity1
		player1.velocity = Vector2.ZERO
		player2.global_position = start_pos2
		player2.polarity = start_polarity2
		player2.velocity = Vector2.ZERO


func _on_pressed():
	for child in winConditions.get_children():
		if not child.pressed:
			child.start_flashing_monitor()
			return
	for child in winConditions.get_children():
		child.start_powering()


func _on_released():
	for child in winConditions.get_children():
		child.stop_powering()
		child.stop_flashing_monitor()


func _on_objective_complete():
	for child in winConditions.get_children():
		if not child.completed:
			return
	player1.teleport_animation()
	player2.teleport_animation()


func _on_objective_complete2():
	if player1.teleported and player2.teleported:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Levels/" + next_level + ".tscn")
