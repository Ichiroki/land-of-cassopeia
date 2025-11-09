extends Node2D

# Get credits label to change its text
@onready var credits = $CanvasLayer/Panel/Credits
@onready var start_game = $CanvasLayer/Panel/VBoxContainer/StartGame
@onready var load_game = $CanvasLayer/Panel/VBoxContainer/LoadGame
@onready var option = $CanvasLayer/Panel/VBoxContainer/Option
@onready var quit_game = $CanvasLayer/Panel/VBoxContainer/QuitGame

# Change the text with _ready() function
func _ready():
	credits._on_change_label_text("Credits")
	start_game._on_change_label_text("Start Game")
	load_game._on_change_label_text("Load Game")
	option._on_change_label_text("Option")
	quit_game._on_change_label_text("Quit Game")

func _on_quit_game_pressed() -> void:
	quit_game._on_pressed()
	get_tree().quit()
