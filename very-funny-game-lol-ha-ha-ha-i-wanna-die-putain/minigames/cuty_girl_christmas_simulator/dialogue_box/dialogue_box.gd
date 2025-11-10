extends Control

signal dialogue_started
signal dialogue_finished
signal click_pressed

@onready var name_rich_text_label: RichTextLabel = $Labels/NameRichTextLabel
@onready var text_rich_text_label: RichTextLabel = $Labels/TextRichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var lines_to_display: Array = []:
	set(value):
		dialogue_started.emit()
		lines_to_display = value
		if animation_player.is_playing():
			await animation_player.animation_finished
		show()
		animation_player.play("popup")
		await animation_player.animation_finished
		for line: Array in value:
			say(line[0], line[1])
			await click_pressed
		animation_player.play("leave")
		await animation_player.animation_finished
		hide()
		dialogue_finished.emit()

func _ready() -> void:
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		click_pressed.emit()

func say(_name: String, _text: String) -> void:
	name_rich_text_label.text = "[u]" + _name + "[/u]"
	text_rich_text_label.text = ""
	for _character: String in _text:
		text_rich_text_label.text += _character
		await get_tree().create_timer(0.1).timeout
