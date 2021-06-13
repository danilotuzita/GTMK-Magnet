extends Control


export(String) var starting_level = "Level1"

var regex = RegEx.new()

onready var mainButtons = $MainButtons
onready var options = $Options
onready var masterVolumeSlider = $Options/MasterVolumeSlider
onready var masterVolumeLabel = $Options/Volume/SliderValue
onready var musicVolumeSlider = $Options/MusicVolume
onready var musicVolumeLabel = $Options/MusicVolume/MusicSliderValue
onready var sfxVolumeSlider = $Options/SFXVolume
onready var sfxVolumeLabel = $Options/SFXVolume/SFXSliderValue

onready var tween = $Tween
onready var tween2 = $Tween2
onready var lightBlue = $LightBlue
onready var lightRed = $LightRed
var tween_values = [.8, 1.2]
var tween_values2 = [.7, 1.3]

func _ready():
	regex.compile("^[0-9]{1,3} *$")
	masterVolumeLabel.placeholder_text = String(masterVolumeSlider.value)
	Configs.bkg_player.play()
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

func _on_Back_pressed():
	mainButtons.visible = true
	options.visible = false


# MASTER VOLUME
func _on_HSlider_value_changed(value):
	masterVolumeLabel.placeholder_text = String(value)
	masterVolumeLabel.text = String(value)
	masterVolumeSlider.value = value
	Configs.master_audio_volume = value / 100

func _on_SliderValue_text_entered(new_text):
	if regex.search(new_text):
		_on_HSlider_value_changed(int(new_text))
	else:
		_on_HSlider_value_changed(masterVolumeSlider.value)

# MUSIC VOLUME
func _on_MusicVolumeSlider_changed(value):
	musicVolumeLabel.placeholder_text = String(value)
	musicVolumeLabel.text = String(value)
	musicVolumeSlider.value = value
	Configs.music_volume = value / 100

func _on_MusicSliderValue_text_entered(new_text):
	if regex.search(new_text):
		_on_MusicVolumeSlider_changed(int(new_text))
	else:
		_on_MusicVolumeSlider_changed(musicVolumeSlider.value)

# SFX VOLUME
func _on_SFXVolumeSlider_value_changed(value):
	sfxVolumeLabel.placeholder_text = String(value)
	sfxVolumeLabel.text = String(value)
	sfxVolumeSlider.value = value
	Configs.sfx_volume = value / 100

func _on_SFXSliderValue_text_entered(new_text):
	if regex.search(new_text):
		_on_SFXVolumeSlider_value_changed(int(new_text))
	else:
		_on_SFXVolumeSlider_value_changed(sfxVolumeSlider.value)
