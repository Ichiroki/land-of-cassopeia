extends Node
class_name AIState

var state_machine: Node
var owner_ref
var ai_data: AIResource
func enter(): pass
func update(delta): pass
func exit(): pass

func set_animation(anim_name: String):
	if owner_ref.has_method("update_animation"):
		owner_ref.update_animation(anim_name)
