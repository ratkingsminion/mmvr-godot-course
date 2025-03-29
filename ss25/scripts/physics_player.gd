extends CharacterBody2D

## physics_player.gd - benutzt in game.tscn

## Dieses Script basiert zum Teil auf dem Template-Script, das für CharacterBody2D erstellt wird -
## es handelt sich um einen sehr einfachen "Character Controller", der eine Bewgung nach links und rechts
## erlaubt, sowie einen Sprung. Es handelt sich daher um einen Controller für einen Sidescroller.
## Da wir eine Top-Down-Perspektive haben, wollen wir stattdessen in alle vier Richtungen laufen können,
## ohne Schwerkraft (und ohne Sprung). Außerdem erlaubt dieser Controller, den Charakter per Maus
## zu steuern und nicht nur über die Tastatur.

## Wir per Mausgesteuert? (Oder per Tastatur?)
@export var mouse_control := false
## Die Bewegungsgeschwindigkeit
@export var speed = 300.0

## Dürfen wir uns bewegen?
var allow_movement := true

func _ready() -> void:
	## Mit einem durch den SceneTree erstellten Timer-Objekt können wir eine bestimmte Anzahl an
	## Sekunden (in diesem Fall 0.5) warten, bevor der*die Spieler*in sich bewegen darf.
	allow_movement = false
	var timer := get_tree().create_timer(0.5)
	## Mit dem await-Keyword wartet diese _ready()-Funktion bis das "timeout"-Signal gefeuert wird,
	## bevor die Ausführung fortgesetzt wird
	await timer.timeout
	allow_movement = true

## Zu Erklärung von _physics_process() - siehe crate.gd
func _physics_process(delta: float) -> void:
	## Ist die "allow_movement"-Variable gleich false, beende die Funktion frühzeitig
	if not allow_movement:
		return

	## Tastatur (oder Gamepad) Steuerung. Mittels "Input.get_vector" erhält man einen Vector2,
	## der immer die Länge 1 oder kleiner besitzt und in die Richtung zeigt, in die man sich
	## bewegen will.
	if not mouse_control:
		var vec := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		## Wir setzen die Bewegungsgeschwindigkeit via "velocity" direkt
		velocity = vec * speed
	
	## Maus-Steuerung.
	if mouse_control:
		## Die Position des Mauscursors relativ zum Spielfenster kann man via get_viewport() oder
		## get_window() erhalten. "mp" ist dann ein Vector2
		var mp := get_viewport().get_mouse_position()
		## Wir möchten aber die Mausposition relativ zur Spielfigur, dies kann man mit einfacher
		## Vektorgeometrie berechnen - die Mausposition subtrahiert von der Position der Spielfigur
		## ergibt den Vektor, der von der Spielfigur zur Mausposition zeigt
		var mouse_vec := mp - position
		## Mit dieser Abfrage stellen wir sicher, dass die Figur nur bewegt wird, wenn der Cursor
		## nicht in der Mitte der Figur ist, und wenn man die linke Maustaste gedrückt hält.
		if mouse_vec.length() > 10.0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			## Mittels normalized() kann man einen Vektor auf die Länge 1 skalieren. Die Richtung
			## bleibt natürlich gleich. Dadurch bewegt sich die Figur immer mit derselben Geschwindigkeit
			velocity = mouse_vec.normalized() * speed
		else:
			velocity = Vector2.ZERO
	
	## Normalerweise wird für einen Character Controller move_and_slide() benutzt, welches eine
	## gute Bewegung anhand der velocity-Variable erzeugt und an Schrägen nicht stoppt. Wir benutzen
	## stattdessen move_and_collide(), damit wir gleich auch wissen, wogegen die Spielfigur gestoßen
	## ist. Das Objekt, das zurückgegeben wird, hat verschiedene Informationen, zum Beispiel den
	## Collider, mit dem kollidiert wurde. Diesen benutzen wir, um ihn wegzustoßen, indem wir ihm
	## die gleiche velocity geben wie gerade die Spielfigur besitzt. Allerdings geht dies nur bei
	## RigidBody2Ds, daher müssen wir mittels "is RigidBody2D" in einer if-Abfrage sicherstellen,
	## dass es sich bei dem angebumsten Collider nicht um einen statischen Body handelt!
	var coll := move_and_collide(velocity * delta)
	if coll:
		var other := coll.get_collider()
		if other is RigidBody2D:
			other.linear_velocity = velocity
	
