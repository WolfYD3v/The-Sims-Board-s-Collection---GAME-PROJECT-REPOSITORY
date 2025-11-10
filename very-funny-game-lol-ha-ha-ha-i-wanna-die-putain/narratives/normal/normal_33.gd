extends Page

@onready var nodes: VBoxContainer = $Nodes
@onready var s_501_salmon_getter: Node2D = $S501SalmonGetter

func _ready() -> void:
	page_loading.free()
	next_button.text = next_button_text
