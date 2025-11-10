extends Node

enum NARRATIVES {
	NORMAL,
	COOKIES,
	CUTE_GIRL_CHIRTMAS
}
var narrative_selected: NARRATIVES = NARRATIVES.NORMAL

enum UPGRADES {
	STORY_TREE,
	SUB_CONTROLS,
	SUB_NARRATIVES_HUB
}
var upgrades: Dictionary[UPGRADES, bool] = {
	UPGRADES.STORY_TREE: false,
	UPGRADES.SUB_CONTROLS: false,
	UPGRADES.SUB_NARRATIVES_HUB: false
}
var upgrade_points: int = 0
var upgrade_idx: int = 0

var current_page: Page = null

func update_variables() -> void:
	upgrade_points = int(LoadSave.save_data["GameRules"]["upgrade_points"])
	upgrade_idx = int(LoadSave.save_data["GameRules"]["upgrade_idx"])
	for unlock_upgrade: UPGRADES in LoadSave.save_data["GameRules"]["upgrades"]:
		upgrades.set(unlock_upgrade, true)

func unlock_all_upgrades() -> void:
	for unlock_upgrade: UPGRADES in upgrades.keys():
		upgrades.set(unlock_upgrade, true)
