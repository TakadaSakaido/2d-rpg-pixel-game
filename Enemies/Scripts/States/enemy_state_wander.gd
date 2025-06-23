class_name EnemyStateWander extends EnemyState

@export var anim_name : String = "Walk"
@export var wander_speed : float = 20.0

@export_category("AI")
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2

## What happen when we initialize this state
func init() -> void:
	pass

## What happen when the player enters this state?
func enter() -> void:
	_timer = randi_range( state_cycles_min, state_cycles_max ) * state_animation_duration
	var rand = randi_range( 0, 3 )
	_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wander_speed  # Set velocity
	enemy.set_direction(_direction)
	enemy.update_animation( anim_name )

## What happen when the player exits this state?
func exit() -> void:
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null

## What happen when _physics_process update in this state?
func Physics( _delta: float ) -> EnemyState:
	return null
