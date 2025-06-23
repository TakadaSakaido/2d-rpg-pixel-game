class_name State_Lift extends State

@export var lift_audio : AudioStream

@onready var carry: Node = $"../Carry"





## What happen when the player enters this state?
func Enter() -> void:
	player.update_animation( "Lift" )
	player.animation_player.animation_finished.connect( state_complete )
	player.audio.stream = lift_audio
	player.audio.play()
	pass


## What happen when the player exits this state?
func Exit() -> void:
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> State:
	player.velocity = Vector2.ZERO
	return null



## What happen when _physics_process update in this state?
func Physics( _delta: float ) -> State:
	return null


## What happen with input events in this state?
func HandledInput( _event: InputEvent ) -> State:
	return null


func state_complete( _a : String ) -> void:
	player.animation_player.animation_finished.disconnect( state_complete )
	state_machine.change_state( carry )
	pass
