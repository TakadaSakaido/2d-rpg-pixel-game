@tool
extends NPCBehavior

const COLORS = [ Color(1,0,0), Color(1,1,0), Color(0,1,0), Color(0,1,1), Color( 0, 0, 0 ), 
Color(1,0,1) ]

@export var walk_speed : float = 30.0

var patrol_location : Array[ PatrolLocation ]
var current_location_index : int = 0
var target : PatrolLocation

var has_started : bool = false
var last_phase : String = ""
var direction : Vector2

@onready var timer: Timer = $Timer



func _ready() -> void:
	gather_patrol_location()
	if Engine.is_editor_hint():
		child_entered_tree.connect( gather_patrol_location )
		child_order_changed.connect( gather_patrol_location )
		return
	
	super()
	if patrol_location.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_location[ 0 ]


func _process( _delta: float ) -> void:
	if Engine.is_editor_hint():
		return
	if npc.global_position.distance_to( target.target_position ) < 1:
			idle_phase()


func gather_patrol_location( _n : Node = null ) -> void:
	patrol_location = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_location.append( c )
	
	if Engine.is_editor_hint():
		if patrol_location.size():
			for i in patrol_location.size():
				var _p = patrol_location[ i ] as PatrolLocation
				
				if not _p.transform_changed.is_connected( gather_patrol_location ):
					_p.transform_changed.connect( gather_patrol_location )
				
				_p.update_label( str( i ) )
				_p.modulate = _get_color_by_index( i )
				
				var _next : PatrolLocation
				if i < patrol_location.size() - 1:
					_next = patrol_location[ i + 1 ]
				else:
					_next = patrol_location[ 0 ]
				_p.update_line( _next.position )
	pass


func start() -> void:
	if npc.do_behavior == false or patrol_location.size() < 2:
		return
	
	if has_started == true:
		if timer.time_left == 0:
			walk_phase()
		return #our idle phase is still waiting for the timer timout
	
	has_started = true
	idle_phase()
	pass


func idle_phase() -> void:
	#IDLE PHASE
	npc.global_position = target.target_position
	npc.state = "Idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	var wait_time : float = target.wait_time
	
	current_location_index += 1
	if current_location_index >= patrol_location.size():
		current_location_index = 0
	
	target = patrol_location[ current_location_index ]
	
	if wait_time > 0:
		timer.start( wait_time )
		await timer.timeout
	
	if npc.do_behavior == false:
		return
	
	walk_phase()
	pass


func walk_phase() -> void:
	#WALK PHASE
	npc.state = "Walk"
	direction = global_position.direction_to( target.target_position )
	npc.direction = direction
	npc.velocity = walk_speed * direction
	npc.update_direction( target.target_position )
	npc.update_animation()


func _get_color_by_index( i : int ) -> Color:
	var color_count : int = COLORS.size()
	while i > color_count - 1:
		i -= color_count
	return COLORS[ i ]
