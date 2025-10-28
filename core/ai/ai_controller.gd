extends Node
class_name AIController

var states = {}
var current_state
var owner_ref
var ai_data

func setup(owner, data):
	owner_ref = owner
	ai_data = data

	# Auto load state sesuai flag
	if ai_data.can_interact:
		add_child(load("res://core/ai/states/interact_state.gd").new())
	
	# Default states
	add_child(load("res://core/ai/states/idle_state.gd").new())
	add_child(load("res://core/ai/states/wander_state.gd").new())

	# Register
	for c in get_children():
		states[c.name.to_lower()] = c
		c.state_machine = self
		c.owner_ref = owner_ref
	
	change_state("idle_state")

func change_state(state_name: String):
	if current_state:
		current_state.exit()
	current_state = states.get(state_name, null)
	if current_state:
		current_state.enter()

func update(delta):
	if current_state:
		current_state.update(delta)
