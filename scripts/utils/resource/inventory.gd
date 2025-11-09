extends Resource

class_name Inventory

signal update

@export var slots: Array[InventorySlot]

func modify_inventory():
	emit_signal("update")

func insert(item: ItemsData):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	update.emit()
	
func to_dict() -> Dictionary:
	var data = []
	for slot in slots:
		if slot.item:
			data.append({
				"item_name": slot.item.item_name,
				"amount": slot.amount
			})
		else:
			data.append(null)
	return {
		"slots": data
	}

func from_dict(data: Dictionary, items_db: Dictionary):
	for i in range(slots.size()):
		var slot_data = data["slots"][i]
		if slot_data != null:
			slots[i].item = items_db[slot_data["item_name"]]
			slots[i].item = slot_data["amount"]
		else:
			slots[i].item = null
			slots[i].amount = 0
