extends Node2D
class_name CutyGirlChristmasSimulator

@onready var camera: Camera2D = $Camera
@onready var dialogue_box: Control = $GUI/DialogHUD/DialogueBox
@onready var pluky: TextureRect = $GUI/DialogHUD/Pluky
@onready var pluky_animation_player: AnimationPlayer = $PlukyAnimationPlayer
@onready var simulator_hud: Control = $GUI/SimulatorHUD
@onready var intro_scene_video_stream_player: VideoStreamPlayer = $GUI/IntroSceneVideoStreamPlayer

var pluky_animations: Array = [
	"enter_from_left",
	"enter_from_right"
]

func _ready() -> void:
	simulator_hud.size.y = 0
	pluky.hide()
	await play_dialogue([
		["Narrator", "Cautions."],
		["Narrator", "This server may make emos vomit. And intentialy bait rage Zail's fans, because of his lack of presence."],
		["Narrator", "You have been warned."]
	], false)
	#intro_scene_video_stream_player.play()
	#await intro_scene_video_stream_player.finished
	await play_dialogue([
		["???", "Oh, hello there!"],
		["???", "I am Pluky, the princess of the Kingdom of Christmas!"],
		["Pluky", "Where there is joy and gift everywhere!"],
		["Pluky", "But look at my kingdom, my charming Christmas is ruined!"],
		["Pluky", "Everything is destroyed!"],
		["Pluky", "This is because of Dadidus, the demon of despair with his belt."],
		["Pluky", "I can't rebuild my kingdom alone, I need your help."],
		["Pluky", "Can you help me?"],
		["Pluky", "Yay! Thank you it represents a lot."]
	])
	simulator_hud.change_hud_height(221.0)

func play_dialogue(lines: Array, is_pluky: bool = true) -> void:
	if is_pluky:
		pluky_animation_player.play(pluky_animations.pick_random())
		pluky.show()
	dialogue_box.lines_to_display = lines
	await dialogue_box.dialogue_finished
	if is_pluky:
		pluky_animation_player.play("leave")
		await pluky_animation_player.animation_finished
		pluky.hide()


func _on_simulator_hud_start_joy_poins_minigame() -> void:
	pass # Replace with function body.
