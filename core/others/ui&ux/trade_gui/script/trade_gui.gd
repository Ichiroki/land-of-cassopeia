extends Control

var is_open = false

func open():
	visible = true
	is_open = true
	get_tree().paused = true

func close(): 
	visible = false
	is_open = false
	Dialogic.VAR.trade_was_opened = false

func _on_close_pressed() -> void:
	get_tree().paused = false
	close()
