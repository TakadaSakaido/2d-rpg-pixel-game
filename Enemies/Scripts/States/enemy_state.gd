class_name EnemyState extends Node


## Stores a reference to the enemy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine


## What happen when we initialize this state
func _init() -> void:
	pass


## What happen when the player enters this state?
func enter() -> void:
	pass


## What happen when the player exits this state?
func exit() -> void:
	pass


## What happen when the _process update in this state?
func process( _delta: float ) -> State:
	return null


## What happen when _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null
