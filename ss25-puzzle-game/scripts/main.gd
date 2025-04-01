class_name Main
extends Node2D

enum State { START, GAME, WIN, LOSE }

static var instance: Main

@export var scenes: Array[PackedScene]

var cur_state: Node

func _ready() -> void:
	instance = self
	change_to(State.START)

func change_to(state: State) -> void:
	if cur_state:
		cur_state.queue_free()
	cur_state = scenes[state].instantiate()
	add_child(cur_state)
