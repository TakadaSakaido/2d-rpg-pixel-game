class_name DarkWizardBoss extends Node2D

const ENERGY_EXPLOSION_SCENE : PackedScene = preload( "res://Levels/Dungeon01/Dark Wizard/EnergyExplosion.tscn" )
const ENERGY_BALL_SCENE : PackedScene = preload( "res://Levels/Dungeon01/Dark Wizard/EnergyOrb.tscn" )

@export var max_hp : int = 10
var hp : int = 10

var audio_hurt : AudioStream = preload( "res://Levels/Dungeon01/Dark Wizard/Audio/boss_hurt.wav" )
var audio_shoot : AudioStream = preload( "res://Levels/Dungeon01/Dark Wizard/Audio/boss_fireball.wav" )

var current_position : int = 0
var positions : Array[ Vector2 ]
var beam_attacks : Array[ BeamAttack ]

var damage_count : int = 0

@onready var animation_player : AnimationPlayer = $BossNode/AnimationPlayer
@onready var animation_player_damage : AnimationPlayer = $BossNode/AnimationPlayerDamage
@onready var cloak_animation_player: AnimationPlayer = $BossNode/CloakSprite/AnimationPlayer

@onready var audio : AudioStreamPlayer2D = $BossNode/AudioStreamPlayer2D
@onready var boss_node : Node2D = $BossNode
@onready var presistent_data_handler : PresistentDataHandler = $PresistentDataHandler
@onready var hurt_box : HurtBox = $BossNode/HurtBox
@onready var hit_box: HitBox = $BossNode/HitBox

@onready var hand_1: Sprite2D = $BossNode/CloakSprite/Hand1
@onready var hand_2: Sprite2D = $BossNode/CloakSprite/Hand2
@onready var hand_1up: Sprite2D = $BossNode/CloakSprite/Hand1UP
@onready var hand_2up: Sprite2D = $BossNode/CloakSprite/Hand2UP
@onready var hand_1side: Sprite2D = $BossNode/CloakSprite/Hand1SIDE
@onready var hand_2side: Sprite2D = $BossNode/CloakSprite/Hand2SIDE
@onready var door_block: TileMapLayer = $"../DoorBlock"



func _ready() -> void:
	presistent_data_handler.get_value()
	if presistent_data_handler.value == true:
		door_block.enabled = false
		queue_free()
		return
	
	hp = max_hp
	
	hit_box.Damaged.connect( damage_taken )
	
	for c in $PositionTargets.get_children():
		positions.append( c.global_position )
	$PositionTargets.visible = false
	
	for b in $BeamAttacks.get_children():
		beam_attacks.append( b )
	
	teleport( 0 )


func _process( _delta: float ) -> void:
	hand_1up.position = hand_1.position
	hand_1up.frame = hand_1.frame + 4
	hand_2up.position = hand_2.position
	hand_2up.frame = hand_2.frame+ 4
	hand_1side.position = hand_1.position
	hand_1side.frame = hand_1.frame + 8
	hand_2side.position = hand_2.position
	hand_2side.frame = hand_2.frame + 12
	pass


func teleport( _location : int ) -> void:
	animation_player.play( "Disappear" )
	enable_hit_boxes( false )
	damage_count = 0
	
	if hp < max_hp:
		shoot_orb()
	
	await get_tree().create_timer( 1 ).timeout
	
	boss_node.global_position = positions[ _location ]
	current_position = _location
	update_animation()
	animation_player.play( "Appear" )
	await animation_player.animation_finished
	idle()
	pass


func idle() -> void:
	enable_hit_boxes()
	
	if randf() <= float(hp) / float(max_hp):
		animation_player.play( "Idle" )
		await animation_player.animation_finished
		if hp < 1:
			return
	
	if damage_count < 1:
		energy_beam_attack()
		animation_player.play( "Cast_spell" )
		await animation_player.animation_finished
	
	if hp < 1:
		return
	
	var _t : int = current_position
	while _t == current_position:
		_t = randi_range( 0, 3 )
	teleport( _t )
	pass


func update_animation() -> void:
	boss_node.scale = Vector2( 1, 1 )
	
	hand_1.visible = false
	hand_2.visible = false
	hand_1up.visible = false
	hand_2up.visible = false
	hand_1side.visible = false
	hand_2side.visible = false
	
	if current_position == 0:
		cloak_animation_player.play( "Down" )
		hand_1.visible = true
		hand_2.visible = true
	elif current_position == 2:
		cloak_animation_player.play( "Up" )
		hand_1up.visible = true
		hand_2up.visible = true
	else :
		cloak_animation_player.play("Side")
		hand_1side.visible = true
		hand_2side.visible = true
		if current_position == 1:
			boss_node.scale = Vector2( -1, 1 )
	pass


func energy_beam_attack() -> void:
	var _b : Array[ int ]
	match current_position:
		0, 2:
			if current_position == 0:
				_b.append( 0 )
				_b.append( randi_range( 1, 2 ) )
			else:
				_b.append( 2 )
				_b.append( randi_range( 0, 1 ) )
			if hp < 5:
				_b.append( randi_range( 3, 5 ) )
		1, 3:
			if current_position == 3:
				_b.append( 5 )
				_b.append( randi_range( 3, 4 ) )
			else:
				_b.append( 3 )
				_b.append( randi_range( 4, 5 ) )
			if hp < 5:
				_b.append( randi_range( 0, 2 ) )
	for b in _b:
		beam_attacks[ b ].attack()


func shoot_orb() -> void:
	var eb : Node2D = ENERGY_BALL_SCENE.instantiate()
	eb.global_position = boss_node.global_position + Vector2( 0, -34 )
	get_parent().add_child.call_deferred( eb )
	play_audio( audio_shoot )


func damage_taken( _hurt_box : HurtBox ) -> void:
	if animation_player_damage.current_animation == "Damaged" or hurt_box.damage == 0:
		return
	play_audio( audio_hurt )
	hp = clampi( hp - _hurt_box.damage, 0, max_hp )
	damage_count += 1
	animation_player_damage.play( "Damaged" )
	animation_player_damage.seek( 0 )
	animation_player_damage.queue( "Default" )
	if hp < 1:
		defeat()
	pass


func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()


func defeat() -> void:
	animation_player.play( "Destroy" )
	enable_hit_boxes( false )
	presistent_data_handler.set_value()
	await animation_player.animation_finished
	door_block.enabled == false


func enable_hit_boxes( _v : bool = true ) -> void:
	hit_box.set_deferred( "monitorable", _v )
	hurt_box.set_deferred( "monitoring", _v )


func explosion( _p : Vector2 = Vector2.ZERO ) -> void:
	var e : Node2D = ENERGY_EXPLOSION_SCENE.instantiate()
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred( e )
	pass
