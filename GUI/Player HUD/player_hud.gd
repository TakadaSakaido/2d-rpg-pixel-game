extends CanvasLayer

@export var button_focus_audio : AudioStream = preload( "res://Title Screen/Audio/menu_focus.wav" )
@export var button_select_audio : AudioStream = preload( "res://Title Screen/Audio/menu_select.wav" )

var hearts : Array[ HeartGUI ] = []

@onready var game_over : Control = $"Control/Game Over"
@onready var continue_button : Button = $"Control/Game Over/VBoxContainer/ContinueButton"
@onready var back_to_title_button : Button = $"Control/Game Over/VBoxContainer/Back to TitleButton"
@onready var animation_player : AnimationPlayer = $"Control/Game Over/AnimationPlayer"
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer



func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	
	hide_game_over_screen()
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	continue_button.pressed.connect( load_game )
	back_to_title_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	back_to_title_button.pressed.connect( title_screen )
	LevelManager.level_load_started.connect( hide_game_over_screen )
	pass



func update_hp( _hp : int, _max_hp : int ) -> void:
	update_max_hp( _max_hp )
	for i in _max_hp:
		update_hearts( i, _hp )
	pass


func update_hearts( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 2, 0, 2 )
	hearts[ _index ].value = _value
	pass


func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5 )
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else :
			hearts[i].visible = false
	pass


func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play( "Show_game_over" )
	await animation_player.animation_finished
	
	if can_continue == true:
		continue_button.grab_focus()
	else :
		back_to_title_button.grab_focus()


func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color( 1, 1, 1, 0 )


func load_game() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	SaveManager.load_game()


func title_screen() -> void:
	play_audio( button_select_audio )
	await  fade_to_black()
	LevelManager.load_new_level( "res://Title Screen/TitleScreen.tscn", "", Vector2.ZERO )
	pass


func fade_to_black() -> bool:
	animation_player.play( "Fade_to_black" )
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true


func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()
