extends "../../npc.gd"

@onready var anim = $AnimatedSprite2D
@onready var ai_controller = $AIController

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	anim.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		ai_controller.change_state("interact")
	
func get_random_response():
	pass
	
func _on_dialogic_signal(argument: String):
	if argument == "open_trade":
		get_tree().create_timer(3).timeout
		_on_trade_gui()
	
func _on_timeline_ended():
	if not $CanvasLayer/TradeGUI.is_open:
		Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	
func show_dialogue():
	Dialogic.start("timeline")

func _on_trade_gui():
	$CanvasLayer/TradeGUI.open()
