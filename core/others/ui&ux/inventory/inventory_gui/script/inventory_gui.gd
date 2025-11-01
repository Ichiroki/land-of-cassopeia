extends Control

@onready var grid = $NinePatchRect/GridContainer
@onready var inventory: Inventory = preload("res://players/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	inventory.update.connect(update_slots)
	update_slots()

func update_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

func _on_button_pressed() -> void:
	close()
