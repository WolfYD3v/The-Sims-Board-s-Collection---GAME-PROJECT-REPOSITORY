extends Node2D
class_name StoryTree

@onready var camera_2d: Camera2D = $Camera2D
@onready var points: Node2D = $Points

const TREE_POINT = preload("uid://co0u25ye4idpp")

var point_position: Vector2 = Vector2.ZERO
var first_point_added: bool = false
var opening_closing_animation_playing: bool = false
var min_camera_zoom: Vector2 = Vector2(3.5, 3.5)
var normal_camera_zoom: Vector2 = Vector2(1.0, 1.0)
var tween

func _ready() -> void:
	SaveGame.story_tree_scene = self
	hide()
	camera_2d.zoom = min_camera_zoom

func open() -> void:
	show()
	change_camera_zoom(normal_camera_zoom, 0.8)

func close() -> void:
	change_camera_zoom(min_camera_zoom, 0.4)
	await get_tree().create_timer(0.5).timeout
	hide()

func change_camera_zoom(zoom: Vector2, changing_time: float) -> void:
	opening_closing_animation_playing = true
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_2d, "zoom", zoom, changing_time)
	await tween.finished
	opening_closing_animation_playing = false

func add_point(type: TreePoint.TYPES, text: String, forced: bool = false) -> void:
	if false and not forced:
		return
	var tree_point_to_add: TreePoint = TREE_POINT.instantiate()
	tree_point_to_add.type = type
	tree_point_to_add.text = text
	points.add_child(tree_point_to_add)
	tree_point_to_add.clicked.connect(_move_camera_to)
	tree_point_to_add.position = point_position
	_change_next_point_position(type)
	if not first_point_added:
		first_point_added = true
		point_position = Vector2.ZERO
		match type:
			TreePoint.TYPES.SERVER:
				_change_next_point_position(TreePoint.TYPES.DOT)
			TreePoint.TYPES.DOT:
				_change_next_point_position(TreePoint.TYPES.SERVER)

func _change_next_point_position(type: TreePoint.TYPES) -> void:
	match type:
		TreePoint.TYPES.SERVER:
			point_position.x += 100.0
		TreePoint.TYPES.DOT:
			point_position.y += 100.0

func _move_camera_to(pos: Vector2) -> void:
	if opening_closing_animation_playing:
		return
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "position", pos, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func clear_points() -> void:
	for point: TreePoint in points.get_children():
		point.free()

func load_saved_points() -> void:
	clear_points()
	var saved_points: Array = LoadSave.save_data["StoryTree"]["points_collection"]
	for point: Array in saved_points:
		add_point(int(point[0]), point[1])
