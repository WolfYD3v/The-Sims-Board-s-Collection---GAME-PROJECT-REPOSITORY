extends Node2D
class_name PageViewer

@onready var control_nodes: CanvasLayer = $ControlNodes
@onready var story_tree: StoryTree = $StoryTree
@onready var input_timer: Timer = $InputTimer
@onready var unlocks_shop: UnlocksShop = $Menus/UnlocksShop
@onready var sub_controls: Control = $Menus/SubControls

@export var start_narrative: GameRules.NARRATIVES = GameRules.NARRATIVES.NORMAL

var first_page_to_read: PackedScene = null
var control_nodes_visible: bool = true
var tween

var page_to_read: PackedScene = null:
	set(value):
		if value:
			page_to_read = value
			load_page()
		else:
			push_error("Cannot load this page, déso pas déso! (value is null)")
var loaded_page: Page = null

var narratives_name: Dictionary[GameRules.NARRATIVES, String] = {
	GameRules.NARRATIVES.NORMAL: "normal",
	GameRules.NARRATIVES.COOKIES: "cookies",
	GameRules.NARRATIVES.CUTE_GIRL_CHIRTMAS: "cuty_girl_christmas"
}
var narrative_name: String = ""
var narrative_page_idx: int = 1

func _ready() -> void:
	GameRules.unlock_all_upgrades()
	SaveGame.page_viewer_scene = self
	sub_controls.visible = GameRules.upgrades.get(GameRules.UPGRADES.SUB_CONTROLS)
	story_tree.hide()
	GameRules.narrative_selected = start_narrative
	set_narrative()
	first_page_to_read = load("res://narratives/" + narrative_name + "/" + narrative_name + "_" + str(narrative_page_idx) + ".tscn")
	page_to_read = first_page_to_read

func _input(_event: InputEvent) -> void:
	if not input_timer.is_stopped() or not GameRules.upgrades.get(GameRules.UPGRADES.STORY_TREE):
		return
	if Input.is_key_pressed(KEY_T):
		input_timer.start()
		control_nodes_visible = not(control_nodes_visible)
		if control_nodes_visible:
			animate_control_nodes_scale(Vector2(0.001, 0.001), 0.8)
		else:
			animate_control_nodes_scale(Vector2(1.0, 1.0), 0.4)
		if control_nodes_visible:
			story_tree.open()
		else:
			story_tree.close()

func load_page() -> void:
	sub_controls.visible = GameRules.upgrades.get(GameRules.UPGRADES.SUB_CONTROLS)
	var child_page = page_to_read.instantiate()
	print("Page: " + child_page.name)
	if child_page is Page:
		control_nodes.add_child(child_page)
		GameRules.current_page = child_page
		loaded_page = child_page
		child_page.next_page_inputed.connect(next_narrative_page)
		child_page.open_unlock_shop.connect(unlocks_shop.open)
		child_page.save_loaded.connect(update_page_viewer)
		child_page.save_loaded.connect(story_tree.load_saved_points)
		if not ResourceLoader.exists("res://narratives/" + narrative_name + "/" + narrative_name + "_" + str(narrative_page_idx + 1) + ".tscn"):
			child_page.cant_continue()
		scan_page_elements()
	else:
		push_error("Cannot load this page, déso pas déso! (not a real Page)")
	story_tree.show()

func next_narrative_page() -> void:
	story_tree.hide()
	remove_all_pages()
	GameRules.upgrade_points += 1
	story_tree.add_point(TreePoint.TYPES.DOT, loaded_page.description)
	narrative_page_idx += 1
	var next_page_to_read_path: String = "res://narratives/" + narrative_name + "/" + narrative_name + "_" + str(narrative_page_idx) + ".tscn"
	if not ResourceLoader.exists(next_page_to_read_path):
		narrative_page_idx = 1
		next_page_to_read_path = "res://narratives/" + narrative_name + "/" + narrative_name + "_" + str(narrative_page_idx) + ".tscn"
	page_to_read = load(next_page_to_read_path)

func set_narrative(next_narrative_page_idx: int = 1) -> void:
	remove_all_pages()
	narrative_name = narratives_name.get(GameRules.narrative_selected)
	narrative_page_idx = next_narrative_page_idx
	var next_page_to_read = load("res://narratives/" + narrative_name + "/" + narrative_name + "_" + str(narrative_page_idx) + ".tscn")
	story_tree.add_point(TreePoint.TYPES.SERVER, narratives_name.get(GameRules.narrative_selected) + " NARRATIVE")
	page_to_read = next_page_to_read

func animate_control_nodes_scale(scale_to_set: Vector2, anim_time: float) -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(control_nodes, "scale", scale_to_set, anim_time)

func scan_page_elements() -> void:
	var page_elements: Array = loaded_page.elements.get_children()
	for element in page_elements:
		if element is ElementLink:
			element.link_clicked.connect(set_narrative)

func remove_all_pages() -> void:
	for c in $ControlNodes.get_children():
		c.queue_free()

func update_page_viewer() -> void:
	remove_all_pages()
	narrative_name = LoadSave.save_data["PageViewer"]["narrative_name"]
	narrative_page_idx = int(LoadSave.save_data["PageViewer"]["narrative_page_idx"])
	var next_page_to_read = load("res://narratives/" + narrative_name + "/" + narrative_name + "_" + str(narrative_page_idx) + ".tscn")
	page_to_read = next_page_to_read

func _on_sub_controls_sub_narratives_hub_selected() -> void:
	page_to_read = load("res://scenes/sub_narratives_hub/sub_narratives_hub.tscn")
