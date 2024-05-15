extends Node

@onready var active_level_id: int  = 1
@onready var active_level_node: Node = null 

func _ready():
	load_level(1)

func load_level(level_id: int):
	active_level_id = level_id
	active_level_node = load("res://Scenes/Levels/" + str(active_level_id) + "/level.tscn").instantiate()
	add_child(active_level_node)

func get_active_level() -> Node:
	return active_level_node

func get_active_sublevel() -> Node:
	return active_level_node.get_active_sublevel()
