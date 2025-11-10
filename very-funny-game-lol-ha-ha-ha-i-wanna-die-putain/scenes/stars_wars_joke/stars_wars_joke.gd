extends Control

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var stop_star_wars_joke_audio_stream_player: AudioStreamPlayer = $StopStarWarsJokeAudioStreamPlayer
@onready var stop_star_wars_joke_animated_sprite_2d: AnimatedSprite2D = $StopStarWarsJokeAnimatedSprite2D
@onready var alerts: Control = $Alerts
@onready var close_alert_button: Button = $Alerts/CloseAlertButton

@export var keep_trollin_goes_on: bool = false

var input_listening: bool = false

func _ready() -> void:
	await close_alert_button.pressed
	alerts.hide()
	if not randi_range(1, 20) == 13:
		get_tree().change_scene_to_file("res://scenes/page_viewer/page_viewer.tscn")
		return
	if keep_trollin_goes_on:
		delete_joke_overused_indicator_file()
	if not FileAccess.file_exists(OS.get_user_data_dir() + "/star_wars_joke_done.txt"):
		video_stream_player.play()
		input_listening = true
		await get_tree().create_timer(0.5).timeout
		var file = FileAccess.open(
			OS.get_user_data_dir() + "/star_wars_joke_done.txt",
			FileAccess.WRITE
		)
		file.store_string("")
		file.close()
		await video_stream_player.finished
	stop_star_wars_joke()

func delete_joke_overused_indicator_file() -> void:
	if FileAccess.file_exists(OS.get_user_data_dir() + "/star_wars_joke_done.txt"):
		DirAccess.remove_absolute(OS.get_user_data_dir() + "/star_wars_joke_done.txt")

func _input(event: InputEvent) -> void:
	if input_listening:
		if event is InputEventMouseButton:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				stop_star_wars_joke(true)

func stop_star_wars_joke(forced: bool = false) -> void:
	if forced:
		if video_stream_player.is_playing():
			video_stream_player.paused = true
		stop_star_wars_joke_audio_stream_player.play()
		#stop_star_wars_joke_animated_sprite_2d.play("start_animation")
		#await stop_star_wars_joke_animated_sprite_2d.animation_finished
		await get_tree().create_timer(1.0).timeout
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/page_viewer/page_viewer.tscn")
