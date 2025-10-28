extends Resource

class_name Inventory

signal update

@export var slots: Array[InventorySlot]

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
	
func sort_by_name():
	slots.sort_custom(_compare_item_name)
	update.emit()

func _compare_item_name(a: InventorySlot, b: InventorySlot) -> int:
	if a.item == null and b.item == null:
		return 0
	elif a.item == null:
		return 1
	elif b.item == null:
		return -1
	else:
		return a.item.item_name.naturalnocasecmp_to(b.item.item_name)
		
func sort_by_price():
	slots.sort_custom(_compare_item_price)

func _compare_item_price(a: InventorySlot, b: InventorySlot):
	if a.item == null or b.item == null:
		return 0
	return a.item.price - b.item.price
