extends Sprite2D

func _process(delta: float) -> void:
	var pos := global_position.y
	var target_scale := remap(pos, 50.0, 180.0, 0.5, 2.0)
	scale = Vector2.ONE * target_scale
