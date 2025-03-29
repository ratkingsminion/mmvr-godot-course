extends Node2D

## my_first_script.gd - benutzt in game.tscn

## Dieses Script demonstriert/enthält verschiedene Methoden, ein Objekt (Node2D)
## hoch und runter bewegen zu lasen

## Die Geschwindigkeit, kann im Inspector verändert werden:
@export var speed: float = 10.0
## Die Amplitude ist der Ausschlag der Bewegung, wird z.B. mit sin() verwendet
@export var amplitude: float = 20.0
## Wir könnten eine Curve-Resource benutzen, deren Verlauf bestimmt, in welcher
## Höhe das Objekt sich zu einem bestimmten Zeitpunkt befindet
@export var curve: Curve

## Manchmal brauchen wir die Startposition auf der Y-Achse, in diese Variable speichern wir sie
var start_y: float
## In die _time-Variable können wir die aktuelle Zeit speichern
var _time: float

## Die _ready()-Funktion wird automatisch von Godot aufgerufen, sobald das Objekt
## existiert im SceneTree
func _ready() -> void:
	## Wir speichern uns die Startposition auf der Y-Achse
	start_y = position.y

## Diese Funktion wird jeden Frame erneut ausgeführt, automatisch
func _process(delta: float) -> void:
	## In dieser Variante setzen wir die Y-Position des Objekts mittels der oben erstellten Kurve.
	## Dazu erhöhen wir "_time" jeweils um den Wert "delta", welcher die Zeit seit dem letzten Frame
	## angibt. Dadurch ist _time nach einer Sekunde relativ exakt 1.0. Mit der Funktion fposmod()
	## stellen wir sicher, dass _time immer im Wertebereich von 0.0 bis 1.0 (siehe zweiter Parameter)
	## bleibt. Denn wenn wir mittels "curve.sample()" die Y-Position des Objekts setzen wollen, muss
	## der Parameter in sample() zwischen 0 und 1 bleiben, ansonsten würde die Animation nicht loopen.
	_time = fposmod(_time + delta, 1.0)
	position.y = start_y + curve.sample(_time) * amplitude
	
	## Eine andere Möglichkeit wäre, einfach sin() zu benutzen, das Objekt also auf einer Sinus-"Welle"
	## zu bewegen. Wie bei der curve brauchen wir den start_y-Wert, ansonsten würde sich das Objekt immer
	## um den Nullpunkt bewegen, anstatt dort wo es in der Szene hingesetzt wurde. Da sin() einen
	## Wert zwischen -1 und 1 zurückgibt, multiplizieren wir es mit "amplitude".
	# position.y = sin(speed * time) * amplitude + start_y
	
	## Eine dritte Möglichkeit (von vielen weiteren) wäre, einfach in if-Abfragen sicherzustellen,
	## dass die Bewgegung des Objekts linear von oben nach unten und umgekehrt verläuft. Statt der
	## Position wird die Zeit abgefragt. Am Ende wird _time auf 0 zurückgesetzt, damit es problemlos
	## von vorne beginnen kann.
	#_time += delta
	#if _time < 2:
	#	position.y += speed * delta
	#elif _time < 4:
	#	position.y -= speed * delta
	#else:
	#	_time = 0
