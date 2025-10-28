extends Node2D

func _on_my_house_area_body_entered(body: Node2D):
	if body.name == "Player":
		get_tree().get_first_node_in_group("GameManager").load_world("res://core/worlds/world_1/myHouse.tscn")
