extends AIState

func enter():
	if !owner_ref.ai_data.can_interact:
		state_machine.change_state("idle_state")
		return
	
	print(owner_ref.ai_data.entity_type, "says:", owner_ref.ai_data.interact_text)
	await get_tree().create_timer(2.0).timeout
	state_machine.change_state("idle_state")
