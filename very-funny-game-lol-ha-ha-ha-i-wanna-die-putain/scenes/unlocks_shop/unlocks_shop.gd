extends Control
class_name UnlocksShop

@onready var upgrade_button: Button = $Nodes/UpgradeButton
@onready var upgrade_points_label: Label = $Nodes/UpgradePointsLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sun: TextureRect = $Sun

var upgrades_array: Array[GameRules.UPGRADES] = [
	GameRules.UPGRADES.STORY_TREE,
	GameRules.UPGRADES.SUB_CONTROLS,
	GameRules.UPGRADES.SUB_NARRATIVES_HUB
]
var upgrades_coast: Array[int] = [
	5,
	12,
	0
]
var unlocks_names_array: Array[String] = [
	"Story Tree",
	"Sub Controls",
	"Sub-NARRATIVES Hub"
]

var tween

func _ready() -> void:
	scale = Vector2(0.01, 0.01)
	hide()

func _process(delta: float) -> void:
	sun.rotation += 0.5 * delta

func open() -> void:
	upgrade_points_label.text = str(GameRules.upgrade_points) + " upgrade points"
	upgrade_button.disabled = not(GameRules.upgrade_points >= upgrades_coast.get(GameRules.upgrade_idx))
	set_upgrade_button()
	animation_player.play("open_anim_house")
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.1).timeout
	show()

func _on_upgrade_button_pressed() -> void:
	GameRules.upgrade_points -= upgrades_coast.get(GameRules.upgrade_idx)
	GameRules.upgrades.set(upgrades_array.get(GameRules.upgrade_idx), true)
	print(GameRules.upgrades.get(upgrades_array.get(GameRules.upgrade_idx)))
	GameRules.upgrade_idx += 1
	close()

func set_upgrade_button() -> void:
	upgrade_button.text = unlocks_names_array.get(GameRules.upgrade_idx) + "\n" + str(upgrades_coast.get(GameRules.upgrade_idx)) + " UPRADES POINTS NEEDED"

func _on_close_button_pressed() -> void:
	close()

func close() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.01, 0.01), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	hide()
