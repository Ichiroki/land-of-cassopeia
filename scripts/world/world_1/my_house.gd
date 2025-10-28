extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().get_first_node_in_group("GameManager").load_world("res://core/worlds/world_1/world_1.tscn")
