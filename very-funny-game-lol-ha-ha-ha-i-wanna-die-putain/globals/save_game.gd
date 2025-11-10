extends Node

var page_viewer_scene: PageViewer = null
var story_tree_scene: StoryTree = null

var USER_DATA_FOLDER = OS.get_user_data_dir()
var FILE_NAME: String = "save.json"

var empty_save_file_content: Dictionary = {
	"GameRules": {
		"upgrades": [],
		"upgrade_idx": 0,
		"upgrade_points": 0
	},
	"PageViewer": {
		"narrative_name": "",
		"narrative_page_idx": 1
	},
	"StoryTree": {
		"points_collection": []
	}
}

func _ready() -> void:
	if not check_for_save_file():
		_create_empty_save()

func check_for_save_file() -> bool:
	return FileAccess.file_exists(USER_DATA_FOLDER + "/" + FILE_NAME)

func delete_save_file() -> void:
	if check_for_save_file():
		DirAccess.remove_absolute(USER_DATA_FOLDER + "/" + FILE_NAME)

func save_game() -> void:
	delete_save_file()
	var save_file = FileAccess.open(USER_DATA_FOLDER + "/" + FILE_NAME, FileAccess.WRITE)
	save_file.store_string(
		JSON.stringify(_create_save_file_content(), "\t", false, true)
	)
	save_file.close()

func _create_empty_save() -> void:
	var save_file = FileAccess.open(USER_DATA_FOLDER + "/" + FILE_NAME, FileAccess.WRITE)
	save_file.store_string(
		JSON.stringify(empty_save_file_content, "\t", false, true)
	)
	save_file.close()

#region SaveFileContentCreation
func _create_save_file_content() -> Dictionary:
	var save_file_content: Dictionary = empty_save_file_content.duplicate_deep()
	save_file_content["GameRules"]["upgrades"] = _get_unlocked_upgrades()
	save_file_content["GameRules"]["upgrade_idx"] = GameRules.upgrade_idx
	save_file_content["GameRules"]["upgrade_points"] = GameRules.upgrade_points
	print(page_viewer_scene.narrative_name)
	save_file_content["PageViewer"]["narrative_name"] = page_viewer_scene.narrative_name
	save_file_content["PageViewer"]["narrative_page_idx"] = page_viewer_scene.narrative_page_idx
	save_file_content["StoryTree"]["points_collection"] = _get_story_tree_points()
	return save_file_content

func _get_unlocked_upgrades() -> Array:
	var unlock_upgrades_array: Array[GameRules.UPGRADES] = []
	for unlock_upgrade: GameRules.UPGRADES in GameRules.upgrades.keys():
		if GameRules.upgrades.get(unlock_upgrade):
			unlock_upgrades_array.append(unlock_upgrade)
	return unlock_upgrades_array

func _get_story_tree_points() -> Array:
	var story_tree_points_collection: Array = []
	for point: TreePoint in story_tree_scene.points.get_children():
		story_tree_points_collection.append([point.type, point.text])
	return story_tree_points_collection
#endregion
