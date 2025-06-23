class_name Plant extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.Damaged.connect( TakeDamage )
	pass # Replace with function body.


func TakeDamage( _damage : HurtBox ) -> void:
	destroy()
	await get_tree().create_timer( 0.3 ).timeout
	queue_free()
	pass

func destroy() -> void:
	if animation_player:
		animation_player.play( "Destroy" )
	pass
