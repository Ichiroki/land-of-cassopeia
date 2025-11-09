extends Control

signal confirm
signal cancel

func open():
	visible = true

func close():
	visible = false

func _on_yes_pressed() -> void:
	emit_signal("confirm")
	close()

func _on_no_pressed() -> void:
	emit_signal("cancel")
	close()
