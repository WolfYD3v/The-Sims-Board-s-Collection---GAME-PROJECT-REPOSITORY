extends CharacterBody2D
class_name S501SalmonGetterPlayer

@export var speed: float = 150.0
@onready var sprite: Sprite2D = $Sprite
@onready var next_walk_step_timer: Timer = $NextWalkStepTimer

var can_move: bool = true

func _physics_process(_delta: float) -> void:
	if not can_move:
		return
	velocity.x = Input.get_axis("s501_salmon_getter_walk_left", "s501_salmon_getter_walk_right") * speed
	velocity.y = Input.get_axis("s501_salmon_getter_walk_up", "s501_salmon_getter_walk_down") * speed
	if velocity:
		if next_walk_step_timer.is_stopped():
			if sprite.frame + 1 > 5:
				sprite.frame = 0
			else:
				sprite.frame += 1
			next_walk_step_timer.start()
	velocity.normalized()
	move_and_slide()
