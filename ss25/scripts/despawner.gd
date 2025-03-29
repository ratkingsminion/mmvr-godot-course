extends Area2D

## despawner.gd - benutzt in spawning.tscn

## Diese Klasse ist sehr simpel - sie leitet von "Area2D" ab, ist also ein "durchlässiger"
## Trigger für Physikobjekte. Dit mit dem "body_entered"-Signal verknüpfte Funktion
## _on_body_entered() wird aufgerufen, wenn ein Physikobjekt in diese Area2D eintritt.
## Das Objekt, das eintritt, wird mittels queue_free() gelöscht.

func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
