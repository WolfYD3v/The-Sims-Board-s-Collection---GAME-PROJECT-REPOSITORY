extends Page

@onready var crime_scene_element_video: VideoStreamPlayer = $CrimeSceneElementVideo

func _ready() -> void:
	crime_scene_element_video.hide()
	allow_scroll = false
	page_scroll_bar.hide()
	page_loading.show()
	banner.hide()
	theme = themes_paths.get(GameRules.narrative_selected)
	banner.texture = banners_paths.get(GameRules.narrative_selected)
	if next_button_text != "":
		next_button.text = next_button_text
	elements.position.y = 0
	page_scroll_bar.max_value = elements.size.y
	if page_scroll_bar.page <= 0.0:
		page_scroll_bar.hide()
	await load_page_content()
	allow_scroll = true

func _on_crime_scene_button_pressed() -> void:
	crime_scene_element_video.show()
	crime_scene_element_video.play()
	await crime_scene_element_video.finished
	next_page_inputed.emit()
