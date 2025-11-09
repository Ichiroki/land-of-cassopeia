extends CharacterBody2D
class_name Player

@export var speed := 100
var direction := Vector2.ZERO
@onready var anim := $AnimatedSprite2D
@export var stats : PlayerStats

var nearby_soil: Node = null
var nearby_crop = null
var nearby_npc: Node = null

var selected_seed: ItemsData = null

var can_act = true

@onready var seed_gui = $PlayerUI/PlantSeedGUI
@onready var gold_gui = $PlayerUI/FrameGUI/HBoxContainer/HBoxContainer/GoldGUI/HBoxContainer/GoldText
@export var inventory: Inventory

func _ready() -> void:
	$PlayerUI/FrameGUI.update_value(str(stats.gold))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if nearby_soil and nearby_soil.can_plant:
			seed_gui.open()
		else:
			seed_gui.close()
		
		if nearby_npc:
			nearby_npc.show_dialogue()
		
		if nearby_crop:
			nearby_crop.harvest(nearby_crop.crop_item, self)
			print(nearby_crop.crop_item)
	
	if not can_act:
		return
	else:
		handle_input()
	move_and_slide()
	update_animation()

func handle_input():
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction.y = -1
	elif Input.is_action_pressed("down"):
		direction.y = 1
		
	if Input.is_action_pressed("left"):
		direction.x = -1
	elif Input.is_action_pressed("right"):
		direction.x = 1
		
	direction = direction.normalized()
	velocity = direction * speed
	
func update_animation():
	if direction == Vector2.ZERO:
		anim.play("idle")
	else:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("walk_side")
				anim.flip_h = true
			else:
				anim.play("walk_side")
				anim.flip_h = false
		else:
			if direction.y < 0:
				anim.play("walk_backward")
			else:
				anim.play("walk")

func player():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:	
	if body.has_method("start_growth"):
		nearby_crop = body
		
	if body.is_in_group("InteractableNPC"):
		nearby_npc = body
		
	if body.has_method("soil"):
		nearby_soil = body
		if nearby_soil.can_plant :
			show_panel()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == nearby_soil:
		close_panel()
		nearby_soil = null

func show_panel():
	$PlayerUI/Panel.visible = true
	
func close_panel():
	$PlayerUI/Panel.visible = false

func start_planting_animation(seed: SeedData):
	close_panel()

	var duration := 5.0
	var value = 0

	if not can_act:
		return

	can_act = false
	anim.play("hoe_left")
	await get_tree().create_timer(duration).timeout
	anim.play("idle")

	plant_seed(seed)
	can_act = true

func plant_seed(seed: SeedData):
	nearby_soil.plant(seed)
