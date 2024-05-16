class_name InteractableComponent extends Node

## Emitted when this object was just interacted with
## See func interact()
signal just_interacted(interacted_by: GridObject, signal_owner: InteractableComponent)

# In case we may want to disable it
@export var is_enabled: bool = true  ## is it ever possible to activate?
@export var is_activated: bool = false  ## initial state. Could be used for syncronization with sprites
@export var activate_by_player: bool = true  ## can directly actiaved by player or by some switch

func _enter_tree() -> void:
	# This component can only be a chld of GridObjects
	assert(owner is GridObject)
	owner.set_meta(&"InteractableComponent", self) # Register

func _exit_tree() -> void:
	owner.remove_meta(&"InteractableComponent") # Unregister


# Let's just have another node handle interactions to keep things simple
# More specialized behavior can also be implemented
#  E.g. `BreakableComponent (extends InteractableComponent)`
# See also func move() in player.gd
func interact(interacted_by: GridObject):
	if not is_enabled:
		return

	if owner.has_component(&"GoThroughComponent"):
		var object = owner.get_component(&"GoThroughComponent")
		object.interact(self)
		
	is_activated = !is_activated  # new state
	just_interacted.emit(interacted_by, self)
