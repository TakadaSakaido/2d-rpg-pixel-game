class_name BeamAttack extends Node2D

@export var use_timer : bool = false
@export var time_between_attack : float = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	if use_timer == true:
		attack_delay()
	pass


func attack() -> void:
	animation_player.play("Attack")
	await animation_player.animation_finished
	animation_player.play("Default")
	if use_timer == true:
		attack_delay()


func attack_delay() -> void:
	await get_tree().create_timer( time_between_attack ).timeout
	attack()
