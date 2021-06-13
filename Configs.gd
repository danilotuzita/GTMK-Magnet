extends Node

var master_audio_volume = .25 setget set_master_audio
var music_volume = 1
var sfx_volume = 1

var bkg_player: AudioStreamPlayer = AudioStreamPlayer.new()
var bkg_music = load("res://Sounds/Music/sci-fi_theme.mp3")

func _ready():
	add_child(bkg_player)
	bkg_player.stream = bkg_music
	bkg_player.volume_db = linear2db((master_audio_volume * music_volume) / 10)

func set_master_audio(volume):
	master_audio_volume = volume
	bkg_player.volume_db = linear2db((master_audio_volume * music_volume) / 10)
