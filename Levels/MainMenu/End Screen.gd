extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Configs.bonus_levels:
		$Label2.visible = false
	Configs.bonus_levels = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Levels/MainMenu/MainMenu.tscn")


func _on_Button2_pressed():
	get_tree().quit()
