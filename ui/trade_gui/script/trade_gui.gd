extends Control
class_name TradeGUI

var is_open = false
@onready var npc_gui = $PanelContainer/NPCTradeGUI/ScrollContainer/MarginContainer/GridContainer.get_children()
@onready var player_gui = $PanelContainer/PlayerTradeGUI/ScrollContainer/MarginContainer/GridContainer.get_children()

var player_inventory = preload("res://entity/players/playerInventory.tres")

signal request_update
signal slot_clicked

var player_inv: Inventory
var npc_inv: Inventory
	
func _ready():
	for slot in player_gui:
		slot.slot_clicked.connect(_on_slot_clicked)
		slot.request_update.connect(_on_slot_request_update)
	
	for slot in npc_gui:
		slot.slot_clicked.connect(_on_slot_clicked)
		slot.request_update.connect(_on_slot_request_update)
	
	if !player_inv:
		return
	else:
		player_inv.connect("update", Callable(self, "refresh_ui"))
		refresh_ui()
	
func open():
	visible = true
	is_open = true

func get_player_inv(inv: Inventory):
	player_inv = inv

func get_npc_inv(inv: Inventory):
	npc_inv = inv

func close(): 
	visible = false
	is_open = false
	Dialogic.VAR.trade_was_opened = false

func _on_close_pressed() -> void:
	SaveManager.save_game(player_inv)
	close()

func _on_slot_request_update():
	update(player_inv, npc_inv)

func _on_slot_clicked(from_inv, index):
	var from_slot = from_inv.slots[index]
	if from_slot.item == null:
		return

	var to_inv = npc_inv if from_inv == player_inv else player_inv

	var moved = false
	
	for slot in to_inv.slots:
		if slot.item == from_slot.item:
			slot.amount += 1
			from_slot.amount -= 1
			moved = true
			break

	if not moved:
		for slot in to_inv.slots:
			if slot.item == null:
				slot.item = from_slot.item
				slot.amount = 1
				from_slot.amount -= 1
				moved = true
				break

	if from_slot.amount <= 0:
		from_slot.item = null
		from_slot.amount = 0

	update(player_inv, npc_inv)

	SaveManager.save_game(player_inv)

func update(player_inv: Inventory, npc_inv: Inventory):
	for i in range(min(player_inv.slots.size(), player_gui.size())):
		player_gui[i].update_slot(player_inv.slots[i])
		player_gui[i].setup(player_inv, i)
		
	for i in range(min(npc_inv.slots.size(), npc_gui.size())):
		npc_gui[i].update_slot(npc_inv.slots[i])
		npc_gui[i].setup(npc_inv, i)

func refresh_ui():
	for i in range(player_inv.slots.size(), player_inventory.slots.size()):
		player_inventory.slots[i].update_slot(player_inv.slots[i])
