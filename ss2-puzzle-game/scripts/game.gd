extends Node2D

@export var player: Player
@export var player_step_audio: AudioStreamPlayer
@export var player_hat_audio: AudioStreamPlayer
@export var level_container: Node2D
@export var tile_scene: PackedScene
@export var step_size := 16
@export var level_sizes: Array[Vector2i]
@export var ui_level_hint: RichTextLabel

const NEIGHBOURS := [ Vector2i.RIGHT, Vector2i.LEFT,
						Vector2i.UP, Vector2i.DOWN ]

var level_idx := 0
var is_moving := false
var tile_pos := Vector2i(5, 5)
var level: Dictionary[Vector2i, Tile]

func _ready() -> void:
	player.position = tile_pos * step_size
	generate_level()
 
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_R:
		if event.is_pressed() and not event.echo:
			Main.instance.change_to(Main.State.GAME)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"): move_player(-1, 0)
	if Input.is_action_pressed("move_right"): move_player(1, 0)
	if Input.is_action_pressed("move_up"): move_player(0, -1)
	if Input.is_action_pressed("move_down"): move_player(0, 1)

func move_player(x: int, y: int) -> void:
	if is_moving: return
	if not tile_pos + Vector2i(x, y) in level: return
	var old_tile_pos := tile_pos
	tile_pos += Vector2i(x, y)
	var target_pos := Vector2(tile_pos) * step_size
	is_moving = true
	player_step_audio.play()
	var tween := get_tree().create_tween()
	tween.tween_property(player, "position", target_pos, 0.2)
	tween.tween_callback(func() -> void:
		is_moving = false
		check_for_hat()
	)
	player.jump(0.2)
	# Zähle Tile-Steps runter
	var old_tile := level[old_tile_pos] as Tile
	old_tile.remove_step()
	if old_tile.steps <= 0:
		tween = get_tree().create_tween()
		tween.tween_property(old_tile, "scale", Vector2.ZERO, 0.3)
		tween.parallel().tween_property(old_tile, "rotation_degrees", randf_range(-45, 45), 0.3)
		tween.tween_callback(old_tile.queue_free)
		level.erase(old_tile_pos)
	# Checke Endstadium
	check_win_or_lose()

func generate_level() -> void:
	is_moving = true
	var level_size := level_sizes[level_idx]
	# Level- und Pfad-Generierung:
	var pos := tile_pos
	for i in randi_range(level_size.x, level_size.y):
		if not pos in level: # Prüfe, ob pos schon in Dictionary
			var tile := tile_scene.instantiate() as Tile
			tile.position = pos * step_size
			level_container.add_child(tile)
			level[pos] = tile
		level[pos].add_step()
		pos += NEIGHBOURS.pick_random()
		#await get_tree().create_timer(0.1).timeout # <- Auskommentieren, wenn man sehen will, wie das Level entsteht
	# Erstelle einen Hut auf einem Tile:
	var hat_pos := tile_pos
	while hat_pos == tile_pos: hat_pos = level.keys().pick_random()
	var power_up_tile := level[hat_pos] as Tile
	power_up_tile.sprite_hat.texture = player.hats[level_idx + 1]
	is_moving = false
	# Text-Animation zu Beginn eines Levels
	ui_level_hint.text = str("[b]LEVEL ", level_idx + 1, " of ", level_sizes.size(), "[/b]")
	var tween := create_tween()
	tween.tween_method(func(f: float) -> void:
		ui_level_hint.get_parent().scale = Vector2.ZERO.lerp(Vector2.ONE, f)
		ui_level_hint.modulate = Color.WHITE.lerp(Color(1,1,1,0), f)
		, 0.0, 1.0, 3.0)

func check_for_hat() -> void:
	if level[tile_pos].sprite_hat.texture:
		player_hat_audio.play()
		player.sprite_hat.texture = level[tile_pos].sprite_hat.texture
		level[tile_pos].sprite_hat.texture = null

func check_win_or_lose() -> void:
	for n in NEIGHBOURS:
		# Wenn man noch Nachbartiles hat, geht das Spiel weiter
		if tile_pos + n in level: return
	await get_tree().create_timer(0.5).timeout
	if level.size() == 1:
		level_idx += 1
		if level_idx >= level_sizes.size():
			Main.instance.change_to(Main.State.WIN)
		else:
			level[tile_pos].remove_step()
			generate_level()
	else:
		Main.instance.change_to(Main.State.LOSE)
