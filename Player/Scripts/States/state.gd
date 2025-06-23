class_name State extends Node

## Store a reference to the player that this State belongs to 
static var player: Player
static  var state_machine : PlayerStateMachine

func _ready() -> void:
	pass # Replace with function body.

## What happen we initialize this state?
func init() -> void:
	pass


## What happen when the player enters this state?
func Enter() -> void:
	pass


## What happen when the player exits this state?
func Exit() -> void:
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> State:
	return null



## What happen when _physics_process update in this state?
func Physics( _delta: float ) -> State:
	return null


## What happen with input events in this state?
func HandledInput( _event: InputEvent ) -> State:
	return null
