extends Control


export(String) var starting_level = "LevelTest"

var regex = RegEx.new()

onready var mainButtons = $MainButtons
onready var options = $Options
onready var masterVolumeSlider = $Options/MasterVolumeSlider
onready var masterVolumeLabel = $Options/Volume/SliderValue

onready var tween = $Tween
onready var tween2 = $Tween2
onready var lightBlue = $LightBlue
onready var lightRed = $LightRed
var tween_values = [.8, 1.2]
var tween_values2 = [.7, 1.3]

func _ready():
	regex.compile("^[0-9]{1,3} *$")
	masterVolumeLabel.placeholder_text = String(masterVolumeSlider.value)
	tween_lights()


func tween_lights():
	tween.interpolate_property(lightBlue, "energy", tween_values[0], tween_values[1], 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween_values.invert()
	tween2.interpolate_property(lightRed, "energy", tween_values[0], tween_values[1], 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween_values.invert()
	tween.start()
	tween2.start()

func _on_Tween_tween_completed(_object, _key):
	tween.interpolate_property(lightBlue, "energy", tween_values[0], tween_values[1], rand_range(1, 2), Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween_values.invert()
	tween.start()

func _on_Tween2_tween_completed(_object, _key):
	tween2.interpolate_property(lightRed, "energy", tween_values2[0], tween_values2[1], rand_range(1, 2), Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween_values2.invert()
	tween2.start()


func _on_StartGame_pressed():
	print("Start the Game")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Levels/" + starting_level + ".tscn")


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


