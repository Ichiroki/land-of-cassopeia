extends AIState

func enter(msg := {}):
	owner.velocity = Vector2.ZERO
	owner.get_random_response()
	owner.show_dialogue()

func exit():
	owner.hide_dialogue()
