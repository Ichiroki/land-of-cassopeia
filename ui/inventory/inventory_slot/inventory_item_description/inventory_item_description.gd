extends NinePatchRect

func _process(delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(16, 16)
