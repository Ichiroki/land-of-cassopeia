extends AIState

func enter():
	owner_ref.update_animation("interact")

func update(delta):
	if ai_data.interact_target:
		pass
