extends CharacterBody2D

## Wie schon das physics_player.gd-Skript entsteht hier ein Character Controller geeignet für ein
## Spiel in Vogelperspektive (d.h. es gibt keine Schwerkraft). Das ganze basiert ebenfalls auf dem
## CharacterBody2D-Standard-Template, wurde aber stark angepasst. In diesem Fall wird demonstriert,
## wie man UI-Buttons zur Steuerung der Spielfigur benutzen kann. Außerdem wird ein AnimationPlayer-
## Node benutzt, um den Character zu animieren, und überdies ein Area2D-Node, um Powerup-Objekte
## einsammeln zu können. All diese Funktionalitäten sind in diesem Script vereint.

## Die Geschwindigkeit der Spielfigur wird in einer Konstante gespeichert, kann also nicht weiter
## verändert werden im Laufe des Spiels.
const SPEED = 100.0

## Um die UI-Buttons direkt ansprechen zu können, packen wir sie in ein Array im Inspector.
@export var buttons: Array[Button]

## Wir holen uns außerdem einen Node vom Type AnimationPlayer mittels eines Node-Pfads. Das $ ist
## hier eine bequeme Abkürzung für die get_node()-Funktion. Da man auf den SceneTree, d.h. die darin
## enthaltenen Nodes, erst in der _ready-Funktion zugreifen kann, gibt es den @onready-Modifier,
## der die Zuweisung zur "anim"-Variable erst kurz vor _ready() ausführt
@onready var anim: AnimationPlayer = $AnimationPlayer

## Diese Member-Variablen werden intern von den Funktionen unten benutzt. "anim_postfix" hilft uns,
## die aktuelle Gehrichtung der Spielfigur zu speichern. "points" speichert nur die ANzahl der eingesammelten
## Powerups, wird aber nicht weiter benutzt fürs Erste. "move_dir" speichert die aktuelle Bewegungsrichtung.
var anim_postfix := ""
var points := 0
var move_dir: Vector2

## _ready() wird zu Beginn der Existenz eines Node-Scripts ausgeführt. Erst erstellen wir einen kleinen
## temporären Array namens "dirs", die die vier kardinalen Richtungen in Vektor-Form enthält.
## Danach verknüpfen wir dementsprechend die Button-Signale mit der Funktion "change_move_dir" -
## wenn der Button gedrückt wird ("button_down"), wird change_move_dir mit dem Parameter dirs[i] auf-
## gerufen, d.h. die entsprechende Gehrichtung (d.h. wir müssen darauf achten, dass die Buttons auch
## in der richtigen Reihenfolge im Array stehen). Wenn der Button losgelassen wird ("button_up"),
## dann wird die Bewgeungsrichtung wieder auf den Null-Vektor zurückgesetzt.
func _ready() -> void:
	var dirs := [ Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN ]
	for i in 4:
		buttons[i].button_down.connect(change_move_dir.bind(dirs[i]))
		buttons[i].button_up.connect(change_move_dir.bind(Vector2.ZERO))

## _physics_process() wird einmal pro Physik-Update aufgerufen. In den Projekteinstellungen wird
## definiert, dass die Physics 60 Mal pro Sekunde aufgerufen werden. Somit kann man sichergehen,
## dass selbst bei 10 Frames pro Sekunde oder bei 400 Frames pro Sekunde, die folgende Funktion
## wirklich nur 60 Mal pro Sekunde aufgerufen wird. (Im Gegensatz zu _process().)
func _physics_process(delta: float) -> void:
	## Bewegung via Actions - eigentlich steuern wir die Figur über die Buttons in der UI,
	## aber man kann ja beides verknüpfen
	var input_move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var final_move_dir := move_dir if move_dir else input_move_dir 
	
	## Da move_dir ein Vektor ist und der Null-Vektor (x=0 und y=0) als "false" interpretiert wird,
	## kann man einfach "if move_dir" abfragen, um festzustellen, ob es gerade eine Eingabe über
	## über die Bewegungsbuttons gibt. Ist dies der Fall, wird die "velocity"-Variable von
	## CharacaterBody2D entsprechend gesetzt. Andernfalls ("else") wird die velocity dem Null-Vektor
	## angenähert (via move_toward().
	if final_move_dir: velocity = final_move_dir * SPEED
	else: velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	## Die folgende Funktion wird aufgerufen, damit die "velocity"-Variable überhaupt benutzt wird.
	## Die Position des Players wird verändert und Kollision berücksichtigt.
	move_and_slide()

	## Die folgende if-Abfrage funktioniert folgerndermaßen:
	## Solange es _keine_ Bewegungsgeschwindigkeit gibt, wird die "idle"-Animation des AnimationPlayer-
	## Nodes abgespielt. Der Animationsname wird mit einem Postfix kombiniert, um zwischen hoch und
	## runter laufen unterscheiden zu können.
	## Sollte es doch eine Geschwindigkeit geben ("else"), wird festgestellt, ob de Geschwindigkeit
	## in y-Richtung ungleich 0 ist, und je nach Richtung der "anim_postfix" angepasst. Danach wird
	## die "walk"-Animation abgespielt, da man sich ja bewegt.
#	if not velocity:
#		anim.play("idle" + anim_postfix)
#	else:
#		if velocity.y < 0: anim_postfix = "_up"
#		elif velocity.y > 0: anim_postfix = "" # down anim
#		anim.play("walk" + anim_postfix)

## Diese Funktion wurde mit der Area2D namens "Checker" verknüpft, bzw. mit deren "area_entered"-Signal.
## Sie soll uns helfen, Powerups einzusammeln. Sie wird nur aufgerufen, wenn die an den Player angeheftete
## Checker-Area2D eine andere Area2D zu überschneiden beginnt.
func _on_checker_area_entered(area: Area2D) -> void:
	## Damit die Spielfigur nicht alles, was eine Area ist, einsammelt, haben wir die Powerups in
	## eine Gruppe (group) namens "collectibles") gepackt. Dies können wir einfach mit is_in_group()
	## abfragen.
	if area.is_in_group("collectibles"):
		points += 10
		
		## Wir animieren das Einsammeln ein wenig, sodass das Powerup nicht sofort verschwindet aus
		## der Szene. Das bedeutet aber auch, dass man sie potentiell zweimal einsammeln könnte.
		## Um dies zu verhindern, wird das Powerup wieder aus der Gruppe "collectibles" entfernt,
		## sodass obige if-Abfrage nicht nochmal true ist. Alternativ hätte man auch die Kollisions-
		## abfrage des Powerups deaktivieren können.
		area.remove_from_group("collectibles")
		
		## Ein Tween animiert ein Property eines Nodes über mehrere Frames hinweg. Ein Tween muss
		## über get_tree() erstellt werden, weil es sonst nicht upgedatet werden würde. (Nur der
		## SceneTree ruft all die _process()-Funktionen auf.)
		var tween := get_tree().create_tween()
		tween.tween_property(area, "modulate", Color(1,0,0,0), 0.5) # Die Farbe des Powerups wird hin zu transparent (alpha=0) animiert
		tween.parallel().tween_property(area, "scale", Vector2(3,3), 0.5) # Parallel(!) dazu wird auch die Skalierung von 1 auf 3 vergrößert
		## Beide Animationen passieren über 0.5 Sekunden.
		
		## Es soll das Powerup auch hin zur Spielfigur fliegen. Wir tun dies mit einer while-Schleife,
		## die aber immer wieder mittels "await" einen Frame lang wartet. Die ganze _on_checker_area_entered()-
		## Funktion wird also über mehrere Frames ausgeführt.
		var factor := 0.0 # Der Faktor ist einfach ein Wert von 0 bis 1, ideal für eine lineare Interpolation (lerp())
		var start_pos := area.global_position # Die Startposition des Powerups wird gespeichert
		while factor < 1.0:
			area.global_position = start_pos.lerp(global_position, factor) # Wir lerpen die Position des Powerups hin zur Position der Spielfigur
			factor += get_process_delta_time() * 2.0 # Da wir in dieser Funktion keinen "delta"-Parameter haben, müssen wir get_process_delta_time() aufrufen
			await get_tree().process_frame # Einen Frame lang warten
		
		## Das Powerup wird nun final gelöscht, nachdem die while-Schleife durch ist
		area.queue_free()
		## Eine kleine Text-Ausgabe im Output-Fenster.
		print("BLING! Points: ", points)

## Diese Methode (aka Funktion) haben wir mit den Buttons verknüpft, damit sie die aktuelle
## Bewegungsrichtung ändern.
func change_move_dir(dir: Vector2) -> void:
	move_dir = dir
