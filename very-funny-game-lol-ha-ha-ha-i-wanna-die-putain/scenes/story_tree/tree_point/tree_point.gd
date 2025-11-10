extends Node2D
class_name TreePoint

signal clicked(pos: Vector2)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var text_gui: CanvasLayer = $TextGUI
@onready var label: Label = $TextGUI/Label

enum TYPES {
	SERVER = 0,
	DOT = 1
}
@export var type: TYPES = TYPES.SERVER

@export var text: String = ""

var normal_scale: Vector2 = Vector2(0.5, 0.5)
var hover_sclale: Vector2 = Vector2(0.55, 0.55)

func _ready() -> void:
	sprite_2d.scale = normal_scale
	text_gui.hide()
	create_shape()

func create_shape() -> void:
	text_gui.get_node("Label").text = text
	if type == TYPES.SERVER:
		await get_tree().create_timer(0.5).timeout
		label.text += "\n" + GameRules.current_page.description
	match type:
		TYPES.SERVER:
			sprite_2d.modulate = Color(0.387, 0.247, 0.172, 1.0)
		TYPES.DOT:
			sprite_2d.modulate = Color(0.056, 0.368, 0.374, 1.0)


func _on_mouse_hover_area_mouse_entered() -> void:
	if get_parent().visible:
		text_gui.show()
		sprite_2d.scale = hover_sclale

func _on_mouse_hover_area_mouse_exited() -> void:
	if get_parent().visible:
		text_gui.hide()
		sprite_2d.scale = normal_scale

func _input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if text_gui.visible:
			clicked.emit(position)
