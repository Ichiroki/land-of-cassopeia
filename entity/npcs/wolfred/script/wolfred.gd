extends "res://entity/npcs/npc.gd"

@onready var anim = $AnimatedSprite2D
@onready var ai_controller = $AIController

@onready var tradeGUI: TradeGUI = $CanvasLayer/TradeGUI

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	anim.play("idle")
	
func _on_dialogic_signal(argument: String):
	if argument == "open_trade":
		_on_trade_gui()
	
func _on_timeline_ended():
	if not tradeGUI.is_open:
		Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	
func show_dialogue():
	Dialogic.start("timeline")

func _on_trade_gui():
	tradeGUI.get_player_inv(player.inventory)
	tradeGUI.get_npc_inv(inventory)
	tradeGUI.update(player.inventory, inventory)
	tradeGUI.open()

func _on_area_2d_body_exited(body: Player) -> void:
	player = null
