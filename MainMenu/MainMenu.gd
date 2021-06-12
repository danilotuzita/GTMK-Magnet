extends Control

var regex = RegEx.new()
onready var mainButtons = $MainButtons
onready var options = $Options
onready var masterVolumeSlider = $Options/MasterVolumeSlider
onready var masterVolumeLabel = $Options/Volume/SliderValue

func _ready():
	regex.compile("^[0-9]{1,3} *$")
	masterVolumeLabel.placeholder_text = String(masterVolumeSlider.value)


func _on_StartGame_pressed():
	print("Start the Game")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_Options_pressed():
	mainButtons.visible = false
	options.visible = true
	print("Open Options")


func _on_QuitGame_pressed():
	print("Quit the Game")
	get_tree().quit()


func _on_HSlider_value_changed(value):
	masterVolumeLabel.placeholder_text = String(value)
	masterVolumeLabel.text = String(value)
	masterVolumeSlider.value = value


func _on_Back_pressed():
	mainButtons.visible = true
	options.visible = false


func _on_SliderValue_text_entered(new_text):
	if regex.search(new_text):
		_on_HSlider_value_changed(int(new_text))
	else:
		_on_HSlider_value_changed(masterVolumeSlider.value)
