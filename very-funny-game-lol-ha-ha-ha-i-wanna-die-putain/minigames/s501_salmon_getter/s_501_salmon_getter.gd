extends Node2D

@onready var s501_salmon_getter_player: S501SalmonGetterPlayer = $S501SalmonGetterPlayer
@onready var officers: Node2D = $Officers
@onready var busted_control: Control = $CanvasLayer/BustedControl
@onready var busted_bg: ColorRect = $CanvasLayer/BustedBG
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var busted_audio_stream_player: AudioStreamPlayer = $BustedAudioStreamPlayer

var base_player_position: Vector2 = Vector2(30.0, 100.0)

func _ready() -> void:
	busted_bg.hide()
	busted_control.hide()
	s501_salmon_getter_player.position = base_player_position
	for officer_node: S501SalmonGetterOfficer in officers.get_children():
		officer_node.player_detected.connect(_player_busted)

func _player_busted() -> void:
	s501_salmon_getter_player.can_move = false
	busted_audio_stream_player.play()
	animation_player.play("busted")
	busted_bg.show()
	busted_control.show()
	await animation_player.animation_finished
	await get_tree().create_timer(2.5).timeout
	busted_bg.hide()
	busted_control.hide()
	s501_salmon_getter_player.position = base_player_position
	s501_salmon_getter_player.can_move = true

func _on_end_area_body_entered(body: Node2D) -> void:
	if body is S501SalmonGetterPlayer:
		queue_free()

func _on_quit_button_pressed() -> void:
	queue_free()
