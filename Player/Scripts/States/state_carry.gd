class_name State_Carry extends State

@export var move_speed : float = 50.0
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"



## What happen when we initialize this state?
func init() -> void:
	pass


## What happen when the player enters this state?
func Enter() -> void:
	player.update_animation( "Carry" )
	walking = false
	pass


## What happen when the player exits this state?
func Exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
		if state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction.rotated( PI )
			throwable.drop()
			pass
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
			pass
		
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation( "Carry" )
	elif player.set_direction() or walking == false:
		player.update_animation( "Carry_walk" )
		walking = true
	player.velocity = player.direction * move_speed
	return null



## What happen when _physics_process update in this state?
func Physics( _delta: float ) -> State:
	return null


## What happen with input events in this state?
func HandledInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed( "attack" ) or _event.is_action_pressed( "interact" ):
		return idle
	return null
