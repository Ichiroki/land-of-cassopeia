extends Control

var inventory_ref
var slot_index: int

@onready var itemTexture = $Button/TextureRect
@onready var amount = $Label

signal request_update
signal slot_clicked(slot_index, inventory_ref)

func setup(inv, index):
	inventory_ref = inv
	slot_index = index

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = {
		"inventory": inventory_ref,
		"index": slot_index
	}
	
	return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.inventory != inventory_ref

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var other_inv = data.inventory
	var other_index = data.index
	
	var temp = inventory_ref.slots[slot_index]
	inventory_ref.slots[slot_index] = other_inv.slots[other_index]
	other_inv.slots[other_index] = temp
	
	inventory_ref.update.emit()
	other_inv.update.emit()
	
	emit_signal("request_update")

func update_slot(inv: InventorySlot):
	if inv.item:
		itemTexture.texture = inv.item.icon
		amount.text = str(inv.amount)
	else:
		itemTexture.texture = null
		amount.text = ""

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("slot_clicked", slot_index, inventory_ref)
