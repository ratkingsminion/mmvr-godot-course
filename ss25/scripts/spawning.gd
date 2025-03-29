extends Node2D

## spawning.gd - benutzt in spawning.tscn

## Dieses Script führt alle Logik der Szene "spawning" aus. Es werden per Klick physikalisierte
## Crates (bouncing_crate) erstellt, und der Hintergrund des Levels wird per Noise generiert.

## Eine Referenz zum bouncing_crate holen wir uns in diesem Fall über eine @export-Variable,
## wir müssen sie also im Inspector zuweisen. Szenen haben den Typ "PackedScene", und es wichtig,
## dass man hier keine zirkulären Referenzen einführt.
@export var box_scene: PackedScene

## Ein Weg, um zirkuläre Referenzen auf jeden Fall zu verhindern, ist die Szene per
## Ressourcen-Pfad und der Funktion "preload" zu holen. Speichert man sie in eine
## Konstante ("const" statt "var"), dann kann die Referenz auch nicht mehr verändert werden.
const TILE_1 = preload("res://scenes/prefabs/tile_1.tscn")
const TILE_2 = preload("res://scenes/prefabs/tile_2.tscn")
const TILE_WHITE = preload("res://scenes/prefabs/tile_white.tscn")

## Die Funktion _input() wird ebenso wie _ready(), _proces(), etc. automatisch von Godot
## aufgerufen. Sie wird immer dann gefeuert, wenn der*die User*in irgendeine Form von
## Eingabe macht - dies kann ein Tastendruck, ein Mausradscroll oder sogar einfach nur eine
## Mausbewegung sein. Der "event: InputEvent" enthält dabei die relevanten Informationen.
## Die Klasse "InputEvent" ist abstrakt, d.h. es gibt auf jeden Fall davon abgeleitete Klassen,
## und im Falle eines Tastendrucks wäre event dann vom Typ "InputEventKey". Dies kann man
## mit "if event is InputEventKey" auch prüfen.
func _input(event: InputEvent) -> void:
	## In diesem Fall fragen wir nur nach, ob der Event ein Mausbutton-Event ist, und
	## welcher Button denn gedrückt wurde - wenn es der linke ist, dann wird der untere
	## Code ausgeführt. Da sowohl das Drücken als auch das Loslassen der Taste einen Event
	## auslöst (also die _input-Funktion aufruft), muss auch geprüft werden, ob
	## "event.pressed" gleich wahr ist.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		## Eine while-Schleife wurde hier zur Demonstration benutzt. Eigentlich wäre eine
		## for-Schleife ("for i in 5") sinnvoller, weil sie nur eine Statt drei Zeilen
		## benötigt - es bräuchte die Zeile "var i: int = 0" und "i += 1" nicht.
		var i: int = 0
		while i < 5:
			## Die Schleife läuft fünf Mal durch und jedes Mal wird ein lokale Variable "pos"
			## angelegt, die eine Zufallsposition zwischen -30 und 30 (sowohl in x- als auch in 
			## y-Richtung) erzeugt. Dafür benutzen wir eine der vielen Zufallsfunktionen, in diesem
			## Fall randf_range().
			var pos := Vector2(randf_range(-30, 30), randf_range(-30, 30))
			## Danach wird eine weitere lokale Variable angelegt - "box_scene" (s.o.) ist ja
			## eine Referenz auf die "bouncing_crate"-Szene, die nun instanziiert (d.h. dupliziert
			## sozusagen) wird. Danach wird die Position dieser Kopie auf die Zufallsposition
			## plus die aktuelle Mausposition (event.position) gesetzt.
			var box: Node2D = box_scene.instantiate()
			box.position = event.position + pos
			## Was man leicht vergessen kann, ist "add_child()" aufzurufen - vergisst man es, erscheint
			## der Bouncing Crate nicht in unserer Szene, denn er wurde nicht dem SceneTree (also der
			## Hierarche unserer Nodes) hinzugefügt und bleibt daher unsichtbar und ohne Funktion.
			## Mittels add_child(box) wird nun der Crate dem Node, an den dieses Script gehangen wurde,
			## als Child hinzugefügt.
			add_child(box)
			i += 1

## Die _ready()-Funktion wird einmalig und automatisch von Godot aufgerufen, sobald der Node mit diesem
## Script in der Szene existiert.
func _ready() -> void:
	generate_background()

## Dies ist eine von uns selbst definierte Funktion, die wir jederzeit aufrufen können. In der Funktion
## "generate_background" soll ein zufällig generierter Hintergrund für unsere Szene erstellt werden
func generate_background() -> void:
	## Zuerst erstellen eine seed-Variable (vom Typ float, also FLießkommazahl), welche zufällig zwischen
	## 0 und 1000 liegt. Diese benutzen wir, damit der Hintergrund tatsächlich bei jedem Aufruf der
	## Funktion anders aussieht.
	var seed := randf_range(0, 1000)
	## Um ein buntes Muster hinzukriegen, das aber nicht komplett zufällig ist, sondern einem Muster
	## folgt, benutzen wir die FastNoiseLite-Klasse, welche verschiedene Methoden zu Generierung von
	## Noise bereitstellt. Wir setzen den Generationsalgorithmus des Noise-Objekts auf Perlinnoise.
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	## Der "tile_scenes"-Array hilft dabei, bequem eins der oben eingeladenen Tile-Szenen auszusuchen
	var tile_scenes: Array = [ TILE_WHITE, TILE_1, TILE_2 ]
	## Hier benutzen wir nun zwei verschachtelte for-Schleifen, die jeweils von 0 bis 19 zählen.
	## for-Schleifen sind eigentlich nur dafür gedacht, über Arrays zu iterieren (also einmal jedes
	## Array-Element abzugreifen), aber wenn man eine Ganzzahl N übergibt, dann wird automatisch ein
	## Array mit den Zahlen 0 bis N erstellt - in diesem Fall [ 0, 1, 2, 3, 4, 5 ...., 17, 18, 19 ].
	for i in 20:
		for j in 20:
			## Der folgende Code wird 20 mal 20 ausgeführt, also 400 Mal. Es werden also 400 Tiles
			## (siehe unten) erstellt. Zuerst aber holen wir uns eine Zahl aus dem Noise-Objekt,
			## anhand der for-Schleifen-Variablen. Da wir den "seed" addieren, der zufällig ist,
			## sehen die Tiles jedes Mal anders aus, weil noise an sich sonst immer dieselben Werte
			## zurückgeben würde.
			## Durch die Multiplikation mit 30 der beiden Parameter erreichen wir, dass das Noise
			## nicht ganz so flächig aussieht. Hier lohnt es sich, mit den Werten herumzuspielen.
			var n := noise.get_noise_2d(i * 20 + seed, j * 20 - seed)
			## Da get_noise_2d() Werte zwischen -1 und 1 zurückgibt, wir aber den Zahlen von 0 bis
			## Länge des Arrays (im obigen Fall 3) minus 1 haben wollen, müssen wir remap() verwenden.
			## Die neue Variable "r" enthält nun eine Zahl zwischen 0 und 2 (da es extrem unwahrscheinlich
			## ist, dass n tatsächlich den Wert 1 erreicht).
			var r: int = remap(n, -1, 1, 0, tile_scenes.size())
			## Wir benutzen "r" nun, um eine der Tile-Szenen aus dem "tile_scenes"-Array zu instanziieren.
			var tile: Node2D = tile_scenes[r].instantiate()
			## Die Position wird entsprechend den for-Variablen gesetzt und mit 64 multipliziert,
			## weil unsere Tile-Szenen jeweils eine Seitenlänge von 64 Pixel haben.
			tile.position = Vector2(i, j) * 64
			add_child(tile)
			## Um das ganze noch mehr zu visualisieren, wird entsprechend dem n-Wert, den wir vorher
			## von [-1,1] auf [0,1] remappen, die Farbigkeit des erstellten Tiles verändert.
			n = remap(n, -1, 1, 0, 1)
			tile.modulate = Color.from_hsv(n, n, 1)
