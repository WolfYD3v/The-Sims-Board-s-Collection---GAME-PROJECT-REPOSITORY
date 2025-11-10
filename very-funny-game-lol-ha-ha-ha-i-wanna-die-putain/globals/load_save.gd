extends Node

var USER_DATA_FOLDER = OS.get_user_data_dir()
var SAVE_NAME: String = "save.json"

var save_data: Dictionary = {}

func load_save() -> void:
	_load_save_file_data()

func _load_save_file_data() -> void:
	if SaveGame.check_for_save_file():
		var save_file = FileAccess.open(USER_DATA_FOLDER + "/" + SAVE_NAME, FileAccess.READ)
		var save_file_data: String = save_file.get_as_text()
		save_file.close()
		save_data = JSON.parse_string(save_file_data)
		print(save_data)
