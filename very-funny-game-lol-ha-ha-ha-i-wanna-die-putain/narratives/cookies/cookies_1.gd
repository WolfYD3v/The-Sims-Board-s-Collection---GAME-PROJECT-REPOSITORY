extends Page

@onready var meteorite_clicker: Control = $MeteoriteClicker
@onready var button: Button = $Nodes/PageArea/PageContent/Elements/Button

func _on_button_pressed() -> void:
	meteorite_clicker.show()
	meteorite_clicker.play()
	get_tree().paused = true
	button.call_deferred("queue_free")
