extends Control

@onready var narrative_label: Label = $Interface/NarrativeLabel
@onready var continue_button: Button = $ContinueButton

var narratives_name_for_label: Dictionary[GameRules.NARRATIVES, String] = {
	GameRules.NARRATIVES.NORMAL: "NORMAL"
}

func _ready() -> void:
	continue_button.disabled = true

func narrative_selected() -> void:
	narrative_label.text = narratives_name_for_label.get(GameRules.narrative_selected) + " SELECTED"
	continue_button.disabled = false

func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
