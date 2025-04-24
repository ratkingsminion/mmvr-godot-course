extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_collects_powerup.connect(_player_collects_powerup)

func _player_collects_powerup(points: int) -> void:
	text = str("Points: ", points * 10)
