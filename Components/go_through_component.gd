class_name GoThroughComponent extends Node

## Emitted when this object was just interacted with
## See func interact()
signal just_interacted(interacted_by: GridObject, signal_owner: GoThroughComponent)

# In case we may want to disable it
@export var is_enabled: bool = true  ## is it ever possible to activate?
@export var is_activated: bool = false  ## player can go through now?
@export var lead_to_level_id: int = -1  ## if this is a door between levels choose positive level id
@export var lead_to_sublevel_id: int = -1  ## if this is a door between sublevels choose positive sublevel id


func _enter_tree() -> void:
	# This component can only be a chld of GridObjects
	assert(owner is GridObject)
	owner.set_meta(&"GoThroughComponent", self) # Register

func _exit_tree() -> void:
	owner.remove_meta(&"GoThroughComponent") # Unregister

func can_player_walk_through() -> bool:
	return is_activated

func interact(interacted_by: Node):
	if not is_enabled and interacted_by != self:
		return
	is_activated = !is_activated  # new state
	just_interacted.emit(interacted_by, self)
