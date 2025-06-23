class_name State_Walk extends State

@export var move_speed : float = 100.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"


## What happen when the player enters this state?
func Enter() -> void:
	player.update_animation( "Walk" )
	pass


## What happen when the player exits this state?
func Exit() -> void:
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("Walk")
	
	return null



## What happen when _physics_process update in this state?
func Physics(_delta: float) -> State:
	return null


## What happen with input events in this state?
func HandledInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed( "interact" ):
		PlayerManager.interact()
	return null
