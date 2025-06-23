class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"



## What happen when the player enters this state?
func Enter() -> void:
	player.update_animation("Idle")
	pass


## What happen when the player exits this state?
func Exit() -> void:
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null



## What happen when _physics_process update in this state?
func Physics( _delta: float ) -> State:
	return null


## What happen with input events in this state?
func HandledInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed( "attack" ):
		return attack
	if _event.is_action_pressed( "interact" ):
		PlayerManager.interact()
	return null
