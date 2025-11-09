extends "res://entity/interactable/farm/crop/crop.gd"

@export var crop_item: ItemsData = preload("res://core/resources/items/vegetable_fruit/corn_item.tres")

@onready var name_label: Label = $Name
@onready var time_label: Label = $Time

func _ready():
	name_label.text = crop_item.item_name
	set_process(true)

func _process(delta: float) -> void:
	time_label.visible = true
	if not is_ready:
		time_label.text = str(round(time_left))
	else:
		time_label.text = "Ready!"
