extends Control
class_name SubControl

signal sub_narratives_hub_selected

@onready var sub_narratives_hub_button: Button = $Controls/SubNARRATIVESHubButton

var tween
var visibility: bool = false:
	set(value):
		visibility = value
		if value:
			update_buttons()
			animate_visibility_size(Vector2(0.0, 900.0))
		else:
			animate_visibility_size(Vector2(401.0, 900.0))

func _ready() -> void:
	size = Vector2(0.0, 900.0)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_S):
		visibility = not(visibility)

func animate_visibility_size(size_to_apply: Vector2) -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "size", size_to_apply, 0.15)

func update_buttons() -> void:
	sub_narratives_hub_button.disabled = not(GameRules.upgrades.get(GameRules.UPGRADES.SUB_NARRATIVES_HUB))

func _on_sub_narratives_hub_button_pressed() -> void:
	if GameRules.upgrades.get(GameRules.UPGRADES.SUB_NARRATIVES_HUB):
		sub_narratives_hub_selected.emit()
		visibility = not(visibility)
