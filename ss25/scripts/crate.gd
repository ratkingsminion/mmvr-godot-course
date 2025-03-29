class_name Crate
extends RigidBody2D

## crate.gd - benutzt in bouncing_crate.tscn (und dadurch in game.tscn und spawning.tscn)

## Das Crate-Skript demonstriert einerseits die Funktionsweise des "body_entered"-
## Signals des RigidBody2D-Nodes (aka RigidBody2D-Klasse, aka RigidBody2D-Typ) -
## sobald die bouncing_crate.tscn-Szene mit einem anderen physikalisierten Objekt
## kollidiert, wird nun _on_body_entered() automatisch aufgerufen, mit dem
## anderen Collider als Parameter ("body: Node").

## Die is_mouse_over-Variable benötigen wir, um zwischenzuspeichern ob der*die
## User*in gerade den Cursor über das Objekt (den Crate-Collider) hält
var is_mouse_over := false

## Diese Funktion wurde verknüpft mit dem body_entered-Signal, und tut nichts
## weiter als die Farbe des Objekts, mit dem kollidiert wurde, zufällig zu
## verändern
func _on_body_entered(body: Node) -> void:
	## Anstatt einer konkreten Farbe (z.B. Color(1,0,0) für rot, oder Color.GREEN für
	## grün), erzeugen wir eine Farbe mittels der Color.from_hsv()-Funktion.
	## randf() gibt einen zufälligen Wert zwischen 0 und 1 zurück, sodass stets
	## eine neue Farbe mit anderem Hue-Wert zurückgegeben wird.
	var new_color := Color.from_hsv(randf(), 1.0, 1.0)
	
	## "modulate" ist ein Property (aka eine Variable), die jeder Node hat, und die
	## grafischen Repräsentationen (Sprite, Mesh, Control, ...) in der Node-
	## Hierarchie einfärbt, wenn man sie auf einen Farbwert anders als weiß setzt.
	## "body.modulate" greift somit auf die "modulate"-Variable des body-Parameters
	## zu, der von der Funktion übergegeben wurde
	body.modulate = new_color

## Im Gegensatz zu _process() wird _physics_process() "fix" aufgerufen. Physikalisierte
## Objekte funktionieren besser, wenn sie nicht mit einem variablen delta-Parameter
## (welcher die Zeit seit dem letzten Frame zurückgibt in Sekunden) manipuliert werden,
## sondern mit einem festen Wert. Daher hat delta: float bei _physics_process() immer
## den gleichen Wert (den man in den Projekteinstellungen verändern kann).
func _physics_process(_delta: float) -> void:
	
	## Die einfachste Variante, um den Crate zu löschen, nachdem er zu tief gefallen
	## ist, ist einfach ständig die aktuelle Y-Position abzufragen; und wenn sie
	## zu niedrig ist (bei 2D-Godot verläuft das Koordinatensystem nach unten, darum fragen
	## wir "ist position.y größer als 500", nicht "niedriger als -500"), dann rufe
	## die Lösch-FUnktion auf. Diese sollte erst am Ende des aktuellen Frames aus-
	## geführt werden, darum nehmen wir "queue_free()", und nicht "free()"
	#if position.y > 500:
		#queue_free()
	
	## Wir fragen nun via der statischen Funktion "is_mouse_button_pressed" von der Input-Klasse
	## ab, ob der rechte Mausbutton gedrückt wird. Zudem muss unsere Variabke "is_mouse_over"
	## ebenfalls "true" sein
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and is_mouse_over:
		## Setzt man die Variable gravity_scale auf 0, hat der RigidBody2D keine Schwerkraft mehr.
		gravity_scale = 0.0
		## Um jegliche Kräfte zu entfernen, wird linear_velocity ebenfalls auf null gesetzt
		linear_velocity = Vector2.ZERO
		## Nun sollte dieses Objekt nicht weiter nach unten fallen.
	else:
		## Sollte is_mouse_over false sein, oder man die rechte Maustaste nicht drücken, wird
		## die Schwerkraft wieder ganz normal auf den Faktor 1 gesetzt
		gravity_scale = 1.0

## _on_mouse_entered() und _on_mouse_exited() sind mit den jeweiligen Signalen des Crate-Nodes
## verknüpft und setzt jeweils einfach "is_mouse_over" auf true oder false, je nachdem ob der
## Mauscursor sich über dem Objekt befindet oder nicht:

func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false
