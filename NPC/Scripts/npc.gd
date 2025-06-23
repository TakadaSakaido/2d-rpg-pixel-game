@tool
@icon( "res://NPC/Icons/npc.svg" )
class_name NPC extends CharacterBody2D

signal do_behavior_enabled

var state : String = "Idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "Down"
var do_behavior : bool = true

@export var npc_resource : NPCResource : set = _set_npc_resoruce

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	setup_npc()
	if Engine.is_editor_hint():
		return
	gather_intractables()
	do_behavior_enabled.emit() 
	pass


func _physics_process( _delta: float ) -> void:
	move_and_slide()


func gather_intractables() -> void:
	for c in get_children():
		if c is DialogInteraction:
			c.player_interacted.connect( _on_player_interacted )
			c.finished.connect( _on_interaction_finished )


func _on_player_interacted() -> void:
	update_direction( PlayerManager.player.global_position )
	state = "Idle"
	velocity = Vector2.ZERO
	update_animation()
	do_behavior = false
	pass


func _on_interaction_finished() -> void:
	state = "Idle"
	update_animation()
	do_behavior = true
	do_behavior_enabled.emit()
	pass


func update_animation() -> void:
	animation.play( state + "_" + direction_name )


func update_direction( target_direction : Vector2 ) -> void:
	direction = global_position.direction_to( target_direction )
	update_direction_name()
	if direction_name == "Side" and direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func update_direction_name() -> void:
	var threshold : float = 0.45
	if direction.y < -threshold:
		direction_name = "Up"
	elif direction.y > threshold:
		direction_name = "Down"
	elif direction.x > threshold || direction.x < -threshold:
		direction_name = "Side"



func setup_npc() -> void:
	if npc_resource:
		if sprite:
			sprite.texture = npc_resource.sprite
	pass


func _set_npc_resoruce( _npc : NPCResource ) -> void:
	npc_resource = _npc
	setup_npc()
