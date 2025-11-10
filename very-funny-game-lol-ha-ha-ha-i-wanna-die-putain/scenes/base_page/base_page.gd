extends Control
class_name Page

signal next_page_inputed
signal open_unlock_shop
signal save_loaded

@onready var page_content: Control = $Nodes/PageArea/PageContent
@onready var page_scroll_bar: VScrollBar = $Nodes/PageArea/PageScrollBar
@onready var elements: VBoxContainer = $Nodes/PageArea/PageContent/Elements
@onready var banner: TextureRect = $Nodes/TopBar/Banner
@onready var next_button: Button = $Nodes/PageArea/PageContent/Elements/DownArea/Buttons/NextButton
@onready var page_loading: ColorRect = $PageLoading

@export var description: String = ""
@export var next_button_text: String = ""

var mouse_in_page_area: bool = false:
	set(value):
		mouse_in_page_area = value
		print(value)
var scroll_speed: float = 35.0

var banners_paths: Dictionary[GameRules.NARRATIVES, Texture2D] = {
	GameRules.NARRATIVES.NORMAL: load("res://assets/banners/normal_banner.png"),
	GameRules.NARRATIVES.COOKIES: load("res://assets/banners/cookie_banner.png")
}
var themes_paths: Dictionary[GameRules.NARRATIVES, Theme] = {
	GameRules.NARRATIVES.NORMAL: load("res://assets/themes/normal_theme.tres"),
	GameRules.NARRATIVES.COOKIES: load("res://assets/themes/cookies_theme.tres")
}

var allow_scroll: bool = true

func _ready() -> void:
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

func _input(event: InputEvent) -> void:
	if not allow_scroll:
		return
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
			if elements.position.y > -page_scroll_bar.max_value:
				page_scroll_bar.value += scroll_speed
			else:
				page_scroll_bar.value = elements.size.y
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
			if elements.position.y < page_scroll_bar.value:
				page_scroll_bar.value -= scroll_speed
			else:
				page_scroll_bar.value = 0

func _on_page_area_mouse_entered() -> void:
	mouse_in_page_area = true

func _on_page_area_mouse_exited() -> void:
	mouse_in_page_area = false

func _on_next_button_pressed() -> void:
	next_page_inputed.emit()

func _on_page_scroll_bar_value_changed(value: float) -> void:
	elements.position.y = -value

func _on_upgrade_shop_button_pressed() -> void:
	open_unlock_shop.emit()

func load_page_content() -> void:
	for element: Control in elements.get_children():
		element.hide()
	for hidden_element: Control in elements.get_children():
		hidden_element.show()
		await get_tree().create_timer(0.2).timeout
	banner.show()
	await get_tree().create_timer(0.2).timeout
	page_scroll_bar.show()
	await get_tree().create_timer(0.1).timeout
	page_loading.hide()

func cant_continue() -> void:
	next_button.hide()

func _on_save_game_button_pressed() -> void:
	SaveGame.save_game()

func _on_load_save_button_pressed() -> void:
	LoadSave.load_save()
	GameRules.update_variables()
	save_loaded.emit()
