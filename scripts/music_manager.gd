# music_manager.gd
extends Node

var music_player = AudioStreamPlayer.new()
var is_initialized = false

func _ready():
	add_child(music_player)
	music_player.bus = "Music"  # Optional: Use a dedicated audio bus
	music_player.volume_db = -10  # Adjust volume as needed
	is_initialized = true

func play_music(stream_path):
	# Only start if not already playing
	if not music_player.playing:
		var music_resource = load(stream_path)
		music_player.stream = music_resource
		music_player.play()

func stop_music():
	music_player.stop()
