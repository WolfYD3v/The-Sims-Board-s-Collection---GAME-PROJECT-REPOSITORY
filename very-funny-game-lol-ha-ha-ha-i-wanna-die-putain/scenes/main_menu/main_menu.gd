extends Control

@onready var background: TextureRect = $Background
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer

var backgrounds: Dictionary[GameRules.NARRATIVES, String] = {
	GameRules.NARRATIVES.NORMAL: "res://icon.svg"
}
var ambiance_songs: Dictionary[GameRules.NARRATIVES, String] = {
	GameRules.NARRATIVES.NORMAL: "res://icon.svg"
}

func _ready() -> void:
	background.texture = load(backgrounds.get(GameRules.narrative_selected))
	ambiance_audio_stream_player.stream = load(ambiance_songs.get(GameRules.narrative_selected))
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file("res://scenes/page_viewer/page_viewer.tscn")
