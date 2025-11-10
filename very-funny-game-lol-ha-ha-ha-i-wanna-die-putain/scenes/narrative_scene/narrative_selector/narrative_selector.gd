extends Control
class_name NarrativeSelector

signal pressed

@onready var icon_button: Button = $Nodes/IconButton

@export var narrative_icon: Texture2D = null
@export var narrative_name: String = ""
@export var narrative_to_select: GameRules.NARRATIVES = GameRules.NARRATIVES.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon_button.icon = narrative_icon
	icon_button.text = narrative_name

func _on_icon_button_pressed() -> void:
	GameRules.narrative_selected = narrative_to_select
	pressed.emit()
