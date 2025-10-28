extends CharacterBody2D
class_name EntityBase

@export var ai_data: AIResource
@onready var ai_controller = $AIController
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	ai_controller.setup(self, ai_data)

func _physics_process(delta: float):
	ai_controller.update(delta)

func update_animation(state: String):
	if anim_player.has_animation(state):
		anim_player.play(state)
