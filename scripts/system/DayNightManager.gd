extends Node2D

@export var day_length: float = 360.0
@onready var color_rect = $CanvasLayer/ColorRect

var time_passed := 0.0

func _process(delta: float) -> void:
	time_passed += delta
	GlobalState.time_of_day = fmod(time_passed, day_length) / day_length
	
	_update_lightning(GlobalState.time_of_day)
	
	if time_passed >= day_length:
		time_passed = 0
		GlobalState.add_day()

func _update_lightning(time_ratio: float):
	var brightness = 1.0 - abs(time_ratio - .5) * 1.5
	brightness = clamp(brightness, .3, 1.0)
	
	color_rect.color = Color(0.1, 0.1, 0.3, 1.0 - brightness)
