extends Page

@onready var credits: Credits = $Credits

func _ready() -> void:
	credits.show()
