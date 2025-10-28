extends Control

var item_slot = null
@onready var sprite: TextureRect = $Button/TextureRect

signal seed_selected(item)

func update(item):
	item_slot = item
	if item_slot:
		sprite.texture = item_slot.icon
	else:
		sprite.texture = null

func _on_button_pressed() -> void:
	if item_slot:
		emit_signal("seed_selected", item_slot)
