class_name TeleportToSublevelComponent extends Node

## Emitted when this object was just interacted with
## See func interact()
signal just_interacted(interacted_by: GridObject, signal_owner: TeleportToSublevelComponent)

@export var sublevel_id: int = 0  ## this portal teleports to sublevel id (id from Level array)

func _enter_tree() -> void:
	# This component can only be a chld of GridObjects
	assert(owner is GridObject)
	owner.set_meta(&"TeleportToSublevelComponent", self) # Register

func _exit_tree() -> void:
	owner.remove_meta(&"TeleportToSublevelComponent") # Unregister

func interact(interacted_by: Node):
	get_tree().current_scene.get_active_level().set_sublevel_by_id(sublevel_id)
	just_interacted.emit(interacted_by, self)
