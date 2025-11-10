extends Control
class_name Credits

@onready var bg_audio_stream_player: AudioStreamPlayer = $BGAudioStreamPlayer
@onready var texts: VBoxContainer = $Texts

func _ready() -> void:
	$Texts/VBoxContainer/HBoxContainer/MinigameButton.hide()
	texts.hide()
	await get_tree().create_timer(0.5).timeout
	texts.show()
	bg_audio_stream_player.play()
	await get_tree().create_timer(25.0).timeout
	get_tree().quit()


func _on_minigame_button_pressed() -> void:
	# Not access
	get_tree().change_scene_to_file("res://minigames/cookie_space_hero/cookie_space_hero.tscn")
