extends Node2D

## world_generator.gd - benutzt in generate.tscn

## Dieses Script zeigt, wie man mithilfe eines Dictionaries eine zufällig generierte
## Welt aus Tiles erzeugen könnte. Wichtig ist vor allem die "dictionary"-Variable,
## welche Informatione über alle bisher generierten Tiles speichert. Ein Dictionary
## speichert Schlüssel-Wert-Paare (Key-Value-Pairs), deren Typen ebenfalls beliebig sein
## können, aber in unserem Fall ist der Key vom Typ Vector2i, also die Position des
## Tiles. Wir benutzen dies, um einen Nachbarn eines zufällig ausgewählten Keys zu
## finden, der noch frei ist, und an diesen erstellen wir das nächste Tile. Dies wird
## 100 Mal (s. for-Schleife) wiederholt.
## Es entsteht bei jedem Start der Szene ein neues Muster.

@export var tile: PackedScene

var cur_pos := Vector2i(5, 5)
var dictionary: Dictionary[Vector2i, Node2D]

func _ready() -> void:
	for i in 100:
		var t := tile.instantiate() ## instanziere ein Tile 
		t.position = cur_pos * 64.0 # setze es auf die aktuelle Position
		add_child(t) # füge das Tile der Szene hinzu
		t.modulate = Color.from_hsv(randf(), 1, 1) # gebe dem Tile eine Zufallsfarbe
		dictionary[cur_pos] = t # füge das Tile dem Dictionary hinzu, mit dem Key der aktuellen Position
		await get_tree().create_timer(0.1).timeout # warte für 0.1 Sekunden
		while dictionary.has(cur_pos): # solange die aktuelle Position schon besetzt ist, füge folgendes aus:
			cur_pos = dictionary.keys().pick_random() # wähle einen zufälligen Key aus und weise es der aktuellen Position zu
			cur_pos += [ Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN ].pick_random() # wähle einen zufälligen Nachbarn der Position aus
