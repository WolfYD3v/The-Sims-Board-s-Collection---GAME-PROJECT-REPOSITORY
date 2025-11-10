extends StaticBody2D
class_name S501SalmonGetterOfficer

signal player_detected

@export var is_static: bool = false
@export_range(-360.0, 360.0, 0.5) var max_rotating: float = 0.0
@export_range(2.0, 20.0, 0.5) var rotation_time: float = 5.0
@export_range(100.0, 1000.0, 1.0) var player_detector_distance: float = 300.0

@onready var player_detector: Node2D = $PlayerDetector

var startng_rotation: float = 0.0
var rotating_tween

func _ready() -> void:
	player_detector.position.x = player_detector_distance
	startng_rotation = rotation
	if not is_static:
		_start_rotating()

func _start_rotating() -> void:
	rotating_tween = get_tree().create_tween()
	rotating_tween.tween_property(self, "rotation_degrees", max_rotating, rotation_time)
	await rotating_tween.finished
	rotating_tween.kill()
	rotating_tween = get_tree().create_tween()
	rotating_tween.tween_property(self, "rotation_degrees", startng_rotation, rotation_time)
	await rotating_tween.finished
	rotating_tween.kill()
	_start_rotating()


func _on_collision_area_body_entered(body: Node2D) -> void:
	if body is S501SalmonGetterPlayer:
		if body.can_move:
			player_detected.emit()
