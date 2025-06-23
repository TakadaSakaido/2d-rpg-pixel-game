extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func fade_out() -> bool:
	animation_player.play( "Fade_out" )
	await animation_player.animation_finished
	return true

func fade_in() -> bool:
	animation_player.play( "Fade_in" )
	#await animation_player.animation_finished
	return true
