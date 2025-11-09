extends StaticBody2D

@export var npc: AIResource
@export var inventory: Inventory
@export var player: Player

func _on_area_2d_player_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body

func _on_area_2d_player_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
