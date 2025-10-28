extends Control

var item_data: InventorySlot = null
var inventory: Inventory

var scroll_speed = 30.0
var scrolling = false

var tween = Tween

@onready var item_visual: TextureRect = $TextureRect
@onready var item_amount: Label = $Amount

func _process(delta):
	if scrolling :
		$Description/Description.scroll_vertical += scroll_speed * delta
		var max_scroll = $Description/Description.get_v_scroll_bar().max_value
		if $Description/Description.scroll_vertical >= max_scroll:
			scrolling = false

func update(slot: InventorySlot):
	item_data = slot
	if !slot.item:
		item_visual.texture = null
		item_visual.visible = false
		item_amount.visible = false
	else:
		item_visual.texture = slot.item.icon
		item_visual.visible = true
		item_amount.visible = true
		item_amount.text = str(slot.amount)

func _get_drag_data(at_position: Vector2):
	if item_data == null or item_data.item == null:
		return null

	var preview_visual = TextureRect.new()
	preview_visual.texture = item_visual.texture
	preview_visual.size = Vector2(90, 90)
	preview_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_visual.modulate = Color(1, 1, 1, 0.8)

	var preview = Control.new()
	preview.add_child(preview_visual)
	preview.z_index = 30

	set_drag_preview(preview)

	return self

func _can_drop_data(at_position: Vector2, data):
	return data is Control and data.has_method("get_item_data")

func _drop_data(at_position: Vector2, data):
	if data == self:
		return
		
	var source_slot = data
	
	var temp_data = item_data
	item_data = source_slot.item_data
	source_slot.item_data = temp_data
	
	swap_item(source_slot)
	update_slot()
	source_slot.update_slot()
	
	if inventory:
		inventory.update.emit()

func swap_item(source_slot):
	if not inventory:
		return

	var this_index = inventory.slots.find(item_data)
	var source_index = inventory.slots.find(source_slot.item_data)

	if this_index != -1 and source_index != -1:
		var temp = inventory.slots[this_index]
		inventory.slots[this_index] = inventory.slots[source_index]
		inventory.slots[source_index] = temp

	var temp_data = item_data
	item_data = source_slot.item_data
	source_slot.item_data = temp_data
	
	update_slot()
	source_slot.update_slot()

	inventory.updated.emit()

func get_item_data():
	return item_data

func update_slot():
	if item_data and item_data.item:
		item_visual.texture = item_data.item.icon
		item_visual.visible = true
		item_amount.visible = true
		item_amount.text = str(item_data.amount)
	else:
		item_visual.texture = null
		item_visual.visible = false
		item_amount.visible = false

func start_scroll():
	$Description/Description.scroll_vertical = 0
	var max_scroll = $Description/Description.get_v_scroll_bar().max_value
	tween = create_tween()
	tween.tween_property($Description/Description, "scroll_vertical", max_scroll, 5.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_scroll():
	if tween:
		tween.kill()
	$Description/Description.scroll_vertical = 0

func _on_mouse_entered() -> void:
	var item = item_data.item
	
	$Description.visible = true
	if $Description.visible:
		$Description/Icon/Texture.texture = item.icon
		$Description/Name/Label.text = item.item_name
		$Description/Rarity/Label.text = item.item_rarity
		
		if item.item_rarity == "common" :
			$Description/Rarity/Label.add_theme_color_override("font_color", Color.AZURE)
		elif item.item_rarity == "uncommon" :
			$Description/Rarity/Label.add_theme_color_override("font_color", Color.CORNFLOWER_BLUE)
		elif item.item_rarity == "rare" :
			$Description/Rarity/Label.add_theme_color_override("font_color", Color.DODGER_BLUE)
		elif item.item_rarity == "epic" :
			$Description/Rarity/Label.add_theme_color_override("font_color", Color.MEDIUM_PURPLE)
		#
		$Description/Description/MarginContainer/Label.text = item.description
	
	start_scroll()

func _on_mouse_exited() -> void:
	$Description.visible = false
	stop_scroll()
