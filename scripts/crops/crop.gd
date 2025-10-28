extends Node2D

@export var growth_stages: Array[Texture2D] = []
@export var grow_time: float = 5.0
@export var crop_data: ItemsData
@export var is_ready := false

var soil_ref: Node2D
var current_stage := 0
var time_left: float
var tween = Tween.new()

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func setup(seed_data: ItemsData, soil: Node2D):
	crop_data = seed_data
	soil_ref = soil
	start_growth()

func crop():
	pass

func start_growth():
	if growth_stages.is_empty():
		push_error("No growth stages assigned!")
		return
	
	current_stage = 0
	is_ready = false
	time_left = grow_time
	sprite.texture = growth_stages[current_stage]

	timer.wait_time = grow_time / growth_stages.size()
	tween.tween_property($Time, "text", 0, timer.wait_time)
	timer.start()

func _process(delta: float) -> void:
	if not is_ready:
		time_left -= delta
		if time_left < 0:
			time_left = 0

func _on_timer_timeout() -> void:
	current_stage += 1
	
	if current_stage < growth_stages.size():
		sprite.texture = growth_stages[current_stage]
	else:
		is_ready = true
		timer.stop()

func harvest(item: ItemsData, player: CharacterBody2D):
	if not is_ready:
		return

	player.inventory.insert(item)
	soil_ref.clear_soil()
	queue_free()
