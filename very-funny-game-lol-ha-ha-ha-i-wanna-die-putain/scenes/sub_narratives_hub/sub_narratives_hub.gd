extends Page

func _ready() -> void:
	$Nodes/PageArea/PageContent/Elements/DownArea.free()
	page_scroll_bar.hide()
	page_loading.show()
	banner.hide()
	if next_button_text != "":
		next_button.text = next_button_text
	elements.position.y = 0
	page_scroll_bar.max_value = elements.size.y
	if page_scroll_bar.page <= 0.0:
		page_scroll_bar.hide()
	load_page_content()
