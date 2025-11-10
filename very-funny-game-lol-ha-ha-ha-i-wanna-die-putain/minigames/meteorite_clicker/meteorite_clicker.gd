extends Control

@onready var meteorite: Button = $Meteorite
@onready var meteorites_label: Label = $MeteoritesLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var background: TextureRect = $Background
@onready var background_animation_player: AnimationPlayer = $BackgroundAnimationPlayer
@onready var goal_rich_text_label: RichTextLabel = $GoalRichTextLabel
@onready var upgrade_points_gaind_label: Label = $UpgradePointsGaindLabel
@onready var planet_1: AnimatedSprite2D = $Background/Planet1
@onready var planet_2: AnimatedSprite2D = $Background/Planet2
@onready var planet_3: AnimatedSprite2D = $Background/Planet3
@onready var cookie_miner_upgrade_button: Button = $UpgradesMenu/Upgrades/CookieMinerUpgradeButton
@onready var upgrade_meteorites_mined_upgrade_button: Button = $UpgradesMenu/Upgrades/UpgradeMeteoritesMinedUpgradeButton
@onready var meteorite_clicked_audio_stream_player: AudioStreamPlayer = $MeteoriteClickedAudioStreamPlayer
@onready var upgrade_buy_audio_stream_player: AudioStreamPlayer = $UpgradeBuyAudioStreamPlayer
@onready var quit_input_blocker: ColorRect = $QuitInputBlocker
@onready var tier_label: Label = $TierLabel
@onready var clicks_info_label: Label = $ClicksInfoLabel
@onready var mining_power_upgrade_button: Button = $UpgradesMenu/Upgrades/MiningPowerUpgradeButton

@export var meteorites_goal: int = 999999999999999

var meteorites_collected: int  = 0
var meteorites: int = 0:
	set(value):
		meteorites = value
		meteorites_label.text = str(meteorites) + " METEORITES"
		update_upgrades_buttons()
		if value >= meteorites_goal:
			quit()

var meteorites_to_add: int = 1

var upgrades_costs: Dictionary[String, int] = {
	"cookie_miner": 15,
	"meteorites_mined": 250,
	"mining_power": 650
}

var cookie_miners_count: int = 0:
	set(value):
		cookie_miners_count = value
		if value > 0:
			auto_mine_meteorite()

var tier: int = 1
var clicks_to_destroy: int = 0
var max_clicks_to_destroy: int = 1

var click_power: int = 1

func _ready() -> void:
	clicks_to_destroy = max_clicks_to_destroy
	clicks_info_label.text = str(clicks_to_destroy) + "/" + str(max_clicks_to_destroy)

func auto_mine_meteorite() -> void:
	await get_tree().create_timer(1.0).timeout
	for loop in range(cookie_miners_count):
		call_deferred("mine_meteorite")
		await get_tree().create_timer(0.5).timeout
	auto_mine_meteorite()

func mine_meteorite() -> void:
	meteorite.rotation += 0.2
	clicks_to_destroy -= click_power
	if clicks_to_destroy <= 0:
		meteorites += meteorites_to_add
		meteorites_collected += meteorites_to_add
		clicks_to_destroy = max_clicks_to_destroy
	if meteorite_clicked_audio_stream_player.playing:
		meteorite_clicked_audio_stream_player.stop()
	meteorite_clicked_audio_stream_player.play()
	goal_rich_text_label.text = "[u]Goal:[/u]" + "\n" + str(meteorites_collected) + "/" + str(meteorites_goal) + "\n" + "METEORITES"
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("pop_meteorite")
	clicks_info_label.text = str(clicks_to_destroy) + "/" + str(max_clicks_to_destroy)

func update_upgrades_buttons() -> void:
	cookie_miner_upgrade_button.disabled = meteorites < upgrades_costs.get("cookie_miner")
	upgrade_meteorites_mined_upgrade_button.disabled = meteorites < upgrades_costs.get("meteorites_mined")
	mining_power_upgrade_button.disabled = meteorites < upgrades_costs.get("mining_power")

func play() -> void:
	$AudioStreamPlayer.play()
	quit_input_blocker.hide()
	upgrade_points_gaind_label.hide()
	meteorites = 0
	update_upgrades_buttons()
	planet_1.play("default")
	planet_2.play("default")
	planet_3.play("default")
	goal_rich_text_label.text = "[u]Goal:[/u]" + "\n" + "0/" + str(meteorites_goal) + "\n" + "METEORITES"
	background_animation_player.play("move")
	animation_player.play("open_tutorial")

func _process(delta: float) -> void:
	if visible:
		meteorite.rotation += 0.1 * delta

func _on_meteorite_pressed() -> void:
	mine_meteorite()

func _on_background_animation_player_animation_finished(_anim_name: StringName) -> void:
	background_animation_player.play("move")


func _on_cookie_miner_upgrade_button_pressed() -> void:
	if meteorites >= upgrades_costs.get("cookie_miner"):
		update_upgrades_buttons()
		meteorites -= upgrades_costs.get("cookie_miner")
		if upgrade_buy_audio_stream_player.playing:
			upgrade_buy_audio_stream_player.stop()
		upgrade_buy_audio_stream_player.play()
		cookie_miners_count += 1
		print(cookie_miners_count)
		upgrades_costs.set(
			"cookie_miner",
			upgrades_costs.get("cookie_miner") + (upgrades_costs.get("cookie_miner")/4) * 3
		)
		cookie_miner_upgrade_button.text = "Buy a cookie miner" + "\n" + "| " + str(upgrades_costs.get("cookie_miner")) + " METEORITES |"

func _on_upgrade_meteorites_mined_upgrade_button_pressed() -> void:
	if meteorites >= upgrades_costs.get("meteorites_mined"):
		update_upgrades_buttons()
		meteorites -= upgrades_costs.get("meteorites_mined")
		if int((meteorites_to_add/4)*3) > 1:
			meteorites_to_add += int((meteorites_to_add/4)*3)
		else:
			meteorites_to_add += 1
		upgrades_costs.set(
			"meteorites_mined",
			upgrades_costs.get("meteorites_mined") + (upgrades_costs.get("meteorites_mined")/4) * 3
		)
		upgrade_meteorites_mined_upgrade_button.text = "Upgrade meteorites mined" + "\n" + "| " + str(upgrades_costs.get("meteorites_mined")) + " METEORITES |"

func _on_quit_button_pressed() -> void:
	quit()

func quit() -> void:
	quit_input_blocker.show()
	upgrade_buy_audio_stream_player.play()
	if meteorites <= 0:
		upgrade_points_gaind_label.text = str(GameRules.upgrade_points) + " upgrade point(s) [+0]"
		upgrade_points_gaind_label.show()
		await get_tree().create_timer(1.5).timeout
		call_deferred("queue_free")
	if not int(0.1 * meteorites) > 1:
		GameRules.upgrade_points += 1 * tier
		upgrade_points_gaind_label.text = str(GameRules.upgrade_points) + " upgrade point(s) [+" + str(1 * tier) + "]"
	else:
		GameRules.upgrade_points += int(0.1 * meteorites)
		upgrade_points_gaind_label.text = str(GameRules.upgrade_points) + " upgrade point(s) [+" + str(int(0.1 * meteorites) * tier) + "]"
	upgrade_points_gaind_label.show()
	await get_tree().create_timer(1.5).timeout
	call_deferred("queue_free")
	get_tree().paused = false

func _on_k_button_pressed() -> void:
	upgrade_buy_audio_stream_player.play()
	animation_player.play("close_tutorial")

func _on_next_tier_button_pressed() -> void:
	tier += 1
	tier_label.text = "Tier " + str(tier)
	meteorites = 3000000
	meteorites_collected = 0
	meteorites_to_add = 1
	cookie_miners_count = 0
	click_power = 1
	upgrades_costs = {
		"cookie_miner": 15,
		"meteorites_mined": 250,
		"mining_power": 650
	}
	upgrade_meteorites_mined_upgrade_button.text = "Upgrade meteorites mined" + "\n" + "| " + str(upgrades_costs.get("meteorites_mined")) + " METEORITES |"
	cookie_miner_upgrade_button.text = "Buy a cookie miner" + "\n" + "| " + str(upgrades_costs.get("cookie_miner")) + " METEORITES |"
	mining_power_upgrade_button.text = "Upgrade mining power" + "\n" + "| " + str(upgrades_costs.get("mining_power")) + " METEORITES |"
	max_clicks_to_destroy *= 2
	clicks_to_destroy = max_clicks_to_destroy
	clicks_info_label.text = str(clicks_to_destroy) + "/" + str(max_clicks_to_destroy)
	update_upgrades_buttons()


func _on_mining_power_upgrade_button_pressed() -> void:
	if meteorites >= upgrades_costs.get("mining_power"):
		update_upgrades_buttons()
		meteorites -= upgrades_costs.get("mining_power")
		click_power += 1
		upgrades_costs.set(
			"mining_power",
			upgrades_costs.get("mining_power") + (upgrades_costs.get("mining_power")/4) * 5
		)
		mining_power_upgrade_button.text = "Upgrade mining power" + "\n" + "| " + str(upgrades_costs.get("mining_power")) + " METEORITES |"
