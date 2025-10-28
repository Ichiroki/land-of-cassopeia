extends CanvasLayer

@onready var inventory = $InventoryGUI
@onready var frameGUI = $FrameGUI

func _process(delta: float) -> void:
	var day = GlobalState.curr_day
	var time_ratio = GlobalState.time_of_day
	
	var phase := ""
	if time_ratio < 0.33:
		phase = "Morning"
	elif time_ratio < 0.66:
		phase = "Afternoon"
	else:
		phase = "Night"
	
	$FrameGUI/Label.text = 'Day %d - %s' % [day, phase]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inventory.is_open == false:
			$InventoryGUI.open()
		else:
			$InventoryGUI.close()
		
