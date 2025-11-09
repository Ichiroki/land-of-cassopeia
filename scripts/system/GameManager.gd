extends Node2D

@onready var world_holder = $WorldHolder
@onready var player = $Player

var curr_world: Node = null

func _ready():
	load_world("res://worlds/world_1/world_1.tscn")

func load_world(path: String):
	if curr_world: 
		curr_world.queue_free()
		await get_tree().process_frame
	
	var new_world = load(path).instantiate()
	world_holder.add_child(new_world)
	curr_world = new_world
	
	var spawn_point = new_world.get_node_or_null("SpawnPoint")
	if spawn_point:
		player.global_position = spawn_point.global_position
