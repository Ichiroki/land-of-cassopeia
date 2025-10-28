extends "crop.gd"

@export var crop_item: ItemsData = preload("res://core/resources/items/vegetable_fruit/corn_item.tres")

func _ready():
	await get_tree().process_frame
	$Name.text = crop_item.item_name
	$Time.text = str(times)
	times = $Timer.time_left
	
func _process(delta: float) -> void:
	if times > 0:
		times -= delta
		$Time.text = str(round(times))
	else:
		times = 0
		set_process(false)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$Name.visible = true
		$Time.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		$Name.visible = false
		$Time.visible = false
