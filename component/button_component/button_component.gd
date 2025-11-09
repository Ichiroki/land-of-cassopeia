extends TextureButton

@onready var label = $Label

# Create function to change text
func _on_change_label_text(val: String):
	label.text = val

func _on_mouse_entered() -> void:
	$AudioStreamPlayer.stream = load("res://assets/sounds/hoverSound.wav")
	$AudioStreamPlayer.play()

func _on_pressed() -> void:
	$AudioStreamPlayer.stream = load("res://assets/sounds/clickSound.wav")
	$AudioStreamPlayer.play()
