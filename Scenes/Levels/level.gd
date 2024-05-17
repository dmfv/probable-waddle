extends Node2D

@export var sublevels: Array[Node] = []
@export var active_sublevel_id: int = 0 ## initial sublevel for the start 

@export var cheats = true

@export var switchers_doors_pathes_dict = {}  ## NodePath: NodePath. dict of NodePath (in editor) which connects switches with doors
var switchers_doors = {}  ## Node: Node. inner array for signal usage

func _ready() -> void:
	active_sublevel_id = sublevels.size() - 1
	set_next_sublevel()
	
	assert(sublevels.size() > 0, "sublevels must be non empty array")
	for switch_node_path in switchers_doors_pathes_dict:
		assert(
			switch_node_path != null and switchers_doors_pathes_dict[switch_node_path],
			"switch and door must be initialized!"
		)
		assert(
			switch_node_path != switchers_doors_pathes_dict[switch_node_path],
			"switch and door must be different nodes!"
		)
		var switch = get_node(switch_node_path)
		switch.get_component(&"InteractableComponent").just_interacted.connect(_on_switch_interacted)
		switchers_doors[switch] = get_node(switchers_doors_pathes_dict[switch_node_path])

# manage sublevels:
func get_active_sublevel() -> SubLevel:
	# TODO: ADD SUBLEVELS TO GROUP
	assert(active_sublevel_id < sublevels.size(), "no sublevel with such id!")
	return sublevels[active_sublevel_id]

func set_sublevel_by_id(id: int) -> void:
	assert(
		id < sublevels.size(),
		"trying to load non existing sublevel id. id must be less than sublevels array."
	)
	disable_sublevel(sublevels[active_sublevel_id])
	active_sublevel_id = id
	enable_sublevel(sublevels[active_sublevel_id])

func set_next_sublevel() -> void:
	disable_sublevel(sublevels[active_sublevel_id])
	active_sublevel_id += 1
	if active_sublevel_id >= sublevels.size():
		active_sublevel_id = 0
	enable_sublevel(sublevels[active_sublevel_id])

func set_prev_sublevel() -> void:
	disable_sublevel(sublevels[active_sublevel_id])
	active_sublevel_id -= 1
	if active_sublevel_id < 0:
		active_sublevel_id = sublevels.size() - 1
	enable_sublevel(sublevels[active_sublevel_id])

func disable_sublevel(sublevel: Node) -> void:
	sublevel.hide()
	sublevel.get_tree().paused = true
	
func enable_sublevel(sublevel: Node) -> void:
	sublevel.show()
	sublevel.get_tree().paused = false

func _input(event: InputEvent) -> void:
	if cheats:
		if event.is_action_pressed("ui_focus_next"):
			set_next_sublevel()
		elif event.is_action_pressed("ui_focus_prev"):
			set_prev_sublevel()

# intersublevel switchers
func flip_switch(switch: Node, set_active: bool) -> void:
	var door = switchers_doors[switch]
	# interact with interactive element
	if door.has_component(&"InteractableComponent"):
		var object = door.get_component(&"InteractableComponent")
		object.interact(switch)
	else:
		# GoThroughtComponent activated in InteractableComponent if it is
		if door.has_component(&"GoThroughComponent"):
			var object = door.get_component(&"GoThroughComponent")
			object.interact(switch)
	

func _on_switch_interacted(interacted_by: GridObject, signal_owner: InteractableComponent) -> void:
	flip_switch(signal_owner.get_parent(), signal_owner.is_enabled)
