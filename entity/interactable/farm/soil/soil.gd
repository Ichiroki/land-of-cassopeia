extends StaticBody2D

@export var soil_texture: Texture2D
@onready var sprite: Sprite2D = $Sprite2D

var player: CharacterBody2D = null

var planted_crop: Node2D = null
var can_plant: bool = true

func _ready():
	sprite.texture = soil_texture

func plant(seed: SeedData):
	if not can_plant:
		return
	
	var crop_scene = seed.crop_scene
	var crop = crop_scene.instantiate()
	
	add_child(crop)
	
	crop.position = Vector2(0, -5)
	crop.setup(seed, self)
	
	planted_crop = crop
	can_plant = false
	
func clear_soil():
	planted_crop = null
	can_plant = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player.show_panel()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player.close_panel()
		player = null

func soil():
	pass
