extends Node

@export var hover_sfx: AudioStream
@export var click_sfx: AudioStream

var player_sfx: AudioStreamPlayer

func _ready():
	player_sfx = AudioStreamPlayer.new()
	add_child(player_sfx)

func play_hover():
	if hover_sfx:
		player_sfx.stream = hover_sfx
		player_sfx.play()

func play_click():
	if click_sfx:
		player_sfx.stream = click_sfx
		player_sfx.play()
