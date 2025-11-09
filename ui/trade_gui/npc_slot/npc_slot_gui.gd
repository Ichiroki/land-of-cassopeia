extends Control

var inventory_ref
var slot_index: int

@onready var itemTexture = $Button/TextureRect
@onready var amount = $Label

var inventory: InventorySlot

signal request_update
signal slot_clicked(inventory_ref, slot_index)

func setup(inv, index):
	inventory_ref = inv
	slot_index = index

func _get_drag_data(at_position: Vector2) -> Variant:
	print("masuk 1")
	var data = {
		"inventory": inventory_ref,
		"index": slot_index
	}
	
	var preview_visual = TextureRect.new()
	preview_visual.texture = inventory.item.icon
	preview_visual.size = Vector2(90, 90)
	preview_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_visual.modulate = Color(1, 1, 1, 0.8)

	var preview = Control.new()
	preview.add_child(preview_visual)
	preview.z_index = 30
	
	return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("masuk 2")
	return data.inventory != inventory_ref

func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("masuk 3")
	var other_inv = data.inventory
	var other_index = data.index
	
	var temp = inventory_ref.slots[slot_index]
	inventory_ref.slots[slot_index] = other_inv.slots[other_index]
	other_inv.slots[other_index] = temp
	
	inventory_ref.update.emit()
	other_inv.update.emit()
	
	emit_signal("request_update")

func update_slot(inv: InventorySlot):
	inventory = inv
	if inventory.item:
		itemTexture.texture = inv.item.icon
		amount.text = str(inv.amount)
	else:
		itemTexture.texture = null
		amount.text = ""

func _on_button_pressed() -> void:
	emit_signal("slot_clicked", inventory_ref, slot_index)
