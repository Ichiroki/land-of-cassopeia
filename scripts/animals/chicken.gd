extends Node2D

@export var speed: float = 30.0
@export var wander_area: Area2D

var target_position: Vector2
var is_wandering := false

var margin = 10

var velocity: Vector2 = Vector2.ZERO

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer

func _ready():
	randomize()
	timer.start(randf_range(1.5, 3.0))

func _process(delta):
	if is_wandering:
		move_toward_target(delta)

func move_toward_target(delta):
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed

	if global_position.distance_to(target_position) < 25:
		stop_and_wait()
	else:
		var new_position = global_position + velocity * delta
		var collision = wander_area.get_node("CollisionShape2D")
		
		if wander_area:
			var shape: RectangleShape2D = collision.shape
			var rect_size = shape.size
			
			var rect_center = collision.global_position
			var rect_min = rect_center - rect_size / 2
			var rect_max = rect_center + rect_size / 2
			
			new_position.x = clamp(new_position.x, rect_min.x, rect_max.x)
			new_position.y = clamp(new_position.y, rect_min.y, rect_max.y)
			
		global_position = new_position
			
		if anim.animation != "walk":
			anim.play("walk")

func stop_and_wait():
	is_wandering = false
	velocity = Vector2.ZERO
	anim.play("idle")
	if not timer.is_stopped():
		timer.stop()
	timer.start(randf_range(2.0, 5.0))


func animals():
	pass

func _on_timer_timeout() -> void:
	if wander_area:
		var shape = wander_area.get_node("CollisionShape2D").shape as RectangleShape2D
		var rect_pos = wander_area.global_position - shape.size / 2
		var rect_size = shape.size
		
		var rand_x = randf_range(rect_pos.x, rect_pos.x + rect_size.x)
		var rand_y = randf_range(rect_pos.y, rect_pos.y + rect_size.y)
		
		target_position = Vector2(rand_x, rand_y)
	else:
		target_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	
	is_wandering = true
	anim.play("walk")
