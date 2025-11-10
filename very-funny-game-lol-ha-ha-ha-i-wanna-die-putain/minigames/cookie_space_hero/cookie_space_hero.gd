extends Control

@onready var hero: TextureRect = $Hero
@onready var meteorite: TextureRect = $Meteorite

var hero_positions: Array[Vector2] = [
	Vector2(0.0, 500.0),
	Vector2(600.0, 500.0),
	Vector2(1200.0, 500.0)
]
var pos_idx: int = 1

var meteorite_positions: Array[Vector2] = [
	Vector2(-202.0, -98.0),
	Vector2(389.0, -108.0),
	Vector2(950.0, -108.0)
]

var speed: float = 5.0

var pts: int = 0

func _ready() -> void:
	$Label.text = str(pts) + " POINTS"
	hero.position = hero_positions[pos_idx]
	spawn_meteorite()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_LEFT):
			pos_idx -= 1
			if pos_idx < 0:
				pos_idx = 2
		if Input.is_key_pressed(KEY_RIGHT):
			pos_idx += 1
			if pos_idx > 2:
				pos_idx = 0
		hero.position = hero_positions[pos_idx]

func spawn_meteorite() -> void:
	var ii: int = randi_range(0, meteorite_positions.size() - 1)
	meteorite.position = meteorite_positions[ii]
	var tween = get_tree().create_tween()
	tween.tween_property(meteorite, "position:y", 600, speed)
	await tween.finished
	if ii == pos_idx:
		get_tree().quit()
	pts += 1
	$Label.text = str(pts) + " POINTS"
	tween.stop()
	tween = get_tree().create_tween()
	tween.tween_property(meteorite, "position:y", 1500, speed)
	await tween.finished
	tween.kill()
	speed -= 0.05
	spawn_meteorite()
