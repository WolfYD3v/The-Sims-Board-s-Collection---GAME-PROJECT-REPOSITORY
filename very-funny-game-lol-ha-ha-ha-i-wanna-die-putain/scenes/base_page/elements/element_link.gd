extends Button
class_name ElementLink

signal link_clicked

@export var narrative_link: GameRules.NARRATIVES = GameRules.NARRATIVES.NORMAL
@export_range(1, 2, 1, "or_greater") var narrative_page_idx_link: int = 1

func _on_pressed() -> void:
	GameRules.narrative_selected = narrative_link
	link_clicked.emit(narrative_page_idx_link)
