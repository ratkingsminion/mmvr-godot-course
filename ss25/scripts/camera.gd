extends Camera2D

## camera.gd - benutzt in zeldalike.tscn

## Das Kamera-Script hat nur den Zweck, einem anderen Objekt zu folgen. Dieses Objekt
## ist zufälligerweise die Player-Figur, aber man könnte es tatsächlich auch dafür be-
## nutzen, um ein beliebiges Node2D einem anderen Node2D folgen zu lassen!

## Mit dem @export-Modifier weist man an, dass eine dem Script zugehörige Variable
## auch im Inspector sicht- und manipulierbar sein soll.

## Die Variable "player" enthält den Node, dem gefolgt werden soll
## Vergisst man, sie im Inspector zuzuweisen ("Assign"), dann erhält man eine Fehlermeldung
@export var player: Node2D
## Der snoothness-Faktor bestimmt, wie weich die Kamera der Spielfigur folgt. Dies
## ist nur im Bereich 0 bis 1 sinnvoll (0 - sofortiges Folgen, 0.9999 - sehr langsames Folgen)
## darum wurde hier @export_range verwendet.
@export_range(0.0, 1.0) var smoothness := 0.9

## Alternativ zu "@export var player" könnte man auch den Player direkt referenzerien
## und benutzen. Allerdings wäre das Script dadurch weniger wiederverwendbar, und
## wenn man den Player in der Scene-Hierarchie verschiebt, muss man den Node-Pfad
## händisch anpassen.
#@onready var player: CharacterBody2D = $"../Player"

## Die _process()-Funktion wird einmal pro Frame aufgerufen - was variabel oft passieren kann,
## je nach Geschwindigkeit des Computers und den Monitor-Einstellungen
func _process(delta: float) -> void:
	
	## Alternativ zu "@export var player" und "@onready var player" kann man der Spielfigur
	## auch als "UniqueName" deklarieren, der Name muss gleich bleiben, aber man muss keinen
	## Node-Pfad angeben
	# var player := %"Player"
	
	## Wir setzen die Position dieses Objekts (der Kamera) auf eine neue Position,
	## die durch die lerp()-Funktion und einer FPS-unabhängigen Berechnung nur langsam
	## ("smooth") sich dem player-Objekt annähert
	position = position.lerp(player.position, (1.0 - smoothness) ** (delta * 60.0))
