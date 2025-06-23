class_name State_Death extends State

@export var exhaust_audio : AudioStream

@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"



## What happen we initialize this state?
func init() -> void:
	pass


## What happen when the player enters this state?
func Enter() -> void:
	player.animation_player.play( "Death" )
	audio.stream = exhaust_audio
	audio.play()
	PlayerHud.show_game_over_screen()
	AudioManager.play_music( null )
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
