extends Control

var is_open = false
var inv: Inventory = preload("res://players/playerInventory.tres")

var is_seed_selected = false

@onready var slots: Array = $ScrollContainer/MarginContainer/Container.get_children()
@onready var confirmationGUI: Control = $ConfirmationGUI

@onready var main_icon = $NinePatchRect/NinePatchRect2/TextureRect
@onready var selected_item = $NinePatchRect/ItemName
@onready var rarity_item = $NinePatchRect/ItemRarity

var item_slot = null
var seed: SeedData = null

signal seed_selected(item)
signal seed_unselected

func _ready() -> void:
	update_seed()
	
	confirmationGUI.connect("confirm", Callable(self, "_on_confirm_plant"))
	confirmationGUI.connect("cancel", Callable(self, "_on_cancel_plant"))

func open():
	is_open = true
	visible = true
	get_tree().paused = true
	
func close():
	is_open = false
	visible = false
	get_tree().paused = false

func _on_close_button_pressed() -> void:
	close()

func update_seed():
	var seed_items := []
	
	for slot in inv.slots:
		if slot.item and slot.item is SeedData:
			seed_items.append(slot.item)
	
	for i in range(slots.size()):
		if i < seed_items.size():
			
			if not slots[i].is_connected("seed_selected", Callable(self, "_on_seed_selected")):
				slots[i].connect("seed_selected", Callable(self, "_on_seed_selected"))
				
			slots[i].update(seed_items[i])
		else:
			slots[i].update(null)

func _on_seed_selected(item: SeedData) -> void:	
	seed = item
	
	main_icon.texture = item.icon
	selected_item.text = item.item_name
	rarity_item.text = item.item_rarity
	
	if item.item_rarity == "common" :
		rarity_item.add_theme_color_override("font_color", Color.AZURE)
	elif item.item_rarity == "uncommon" :
		rarity_item.add_theme_color_override("font_color", Color.CORNFLOWER_BLUE)
	elif item.item_rarity == "rare" :
		rarity_item.add_theme_color_override("font_color", Color.DODGER_BLUE)
	elif item.item_rarity == "epic" :
		rarity_item.add_theme_color_override("font_color", Color.MEDIUM_PURPLE)
	
	is_seed_selected = true

func _on_button_pressed() -> void:
	if is_seed_selected:
		$ConfirmationGUI.open()
	else:
		pass
	
func _on_confirm_plant():
	var player = get_parent().get_parent()
	close()
	player.start_planting_animation(seed)

func _on_cancel_pressed() -> void:
	main_icon.texture = null
	selected_item.text = ""
	rarity_item.text = ""
