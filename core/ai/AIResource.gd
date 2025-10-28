extends Resource

class_name AIResource

@export var entity_type := "npc"
@export var bot_name: String = "Unnamed"
@export var move_speed: float = 10.0
@export var can_interact := false
@export var can_wander: bool = true
@export var wander_radius: float = 200.0
@export var interact_text: String = "..."
@export var hostility := "neutral"
