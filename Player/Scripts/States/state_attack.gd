class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range( 1,20,0.5 ) var decelerate_speed : float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var charge_attack: State = $"../ChargeAttack"
@onready var hurt_box: HurtBox = %AttackHurtBox



## What happen when the player enters this state?
func Enter() -> void:
	player.update_animation( "Attack" )
	attack_anim.play( "Attack_" + player.AnimDirectioan() )
	animation_player.animation_finished.connect( EndAttack )
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 0.9 , 1.1 )
	audio.play()
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout
	if attacking:
		hurt_box.monitoring = true
	pass


## What happen when the player exits this state?
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	hurt_box.monitoring = false
	pass

## What happen when the _process update in this state?
func Process( _delta: float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null



## What happen when _physics_process update in this state?
func Physics( _delta: float ) -> State:
	return null


## What happen with input events in this state?
func HandledInput( _event: InputEvent ) -> State:
	return null


func EndAttack( _newAnimName: String ) -> void:
	if Input.is_action_pressed( "attack" ):
		state_machine.change_state( charge_attack )
	attacking = false
