extends Control

signal start_joy_poins_minigame

@onready var boule_noeal: TextureRect = $HUDOrganisation/BouleNoeal
@onready var joy_points_counter_label: Label = $HUDOrganisation/Sectors/JoyPointsSector/JoyPointsCounterLabel
@onready var completion_pourcentage_label: Label = $HUDOrganisation/Sectors/CompletionSector/CompletionPourcentageLabel
@onready var completion_progress_bar: ProgressBar = $HUDOrganisation/Sectors/CompletionSector/CompletionProgressBar

var tween

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	boule_noeal.rotation_degrees += 0.1

func _on_get_joy_points_button_pressed() -> void:
	start_joy_poins_minigame.emit()

func set_joy_points_hud(value: int) -> void:
	joy_points_counter_label.text = str(value) + " JP"

func update_completion(pourcentage: float) -> void:
	completion_pourcentage_label.text = str(pourcentage) + "/100%"
	completion_progress_bar.value = pourcentage

func change_hud_height(value: float) -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "size:y", value, 1.0)
