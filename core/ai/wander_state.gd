extends AIState

var target
var timer = 0.0

func enter():
	target = owner_ref.global_position + Vector2(
		randf_range(-owner_ref.ai_data.wander_radius, owner_ref.ai_data.wander_radius),
		randf_range(-owner_ref.ai_data.wander_radius, owner_ref.ai_data.wander_radius)
	)
	timer = 0.0

func update(delta):
	timer += delta
	var dir = (target - owner_ref.global_position).normalized()
	owner_ref.velocity = dir * owner_ref.ai_data.move_speed
	owner_ref.move_and_slide()
	
	if owner_ref.global_position.distance_to(target) < 10 or timer > 3:
		state_machine.change_state("idle_state")
