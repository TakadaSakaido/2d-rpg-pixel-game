class_name BarredDoor extends Node2D



@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	pass


func open_door() -> void:
	animation_player.play( "Open_door" )
	PlayerManager.shake_camera()
	pass


func close_door() -> void:
	animation_player.play( "Close_door" )
	PlayerManager.shake_camera()
	pass
