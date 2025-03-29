extends Node2D

## player.gd

## Dieses Script für einen so genannten "Character Controller" ist die einfachste
## Variante für eine Tastatur/Gamepad-Steuerung, die es gibt. Es wird in der _process()-
## Funktion permanent die aktuelle Bewegungsrichtung abgefragt (s. physics_player.gd)
## und die Position dementsprechend verändert. Dadurch gibt es aber keinerlei Kollision
## mit Wänden oder sonstige Features.

@export var speed: float = 350.0

func _process(delta: float) -> void:
	var vec := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += vec * speed * delta
