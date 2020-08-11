extends KinematicBody2D

onready var sprite = $Sprite

const DISTANCE_THRESHOLD = 30.0
export var slow_radius = 200.0

export var max_speed = 500.0
var _velocity = Vector2.ZERO

var behaviour: String
var target_global_position = Vector2.ZERO

func _ready():
	set_physics_process(false)
	behaviour = "stop"


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		target_global_position = get_global_mouse_position()
		set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("click"):
		target_global_position = get_global_mouse_position()
	
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD:
		if behaviour == "stop":
			if Input.is_action_pressed("click"):
				pass
			else:
				set_physics_process(false)
		if behaviour == "continue":
			# find direction
			# continue in the direction we were last in
			pass
	#print(global_position.distance_to(target_global_position))
	_velocity = $Steering.arrive_to(
		_velocity,
		global_position,
		target_global_position,
		max_speed,
		slow_radius
	)
	
	_velocity = move_and_slide(_velocity)
	sprite.rotation = _velocity.angle()
#	_velocity = $Steering.follow(
#		_velocity,
#		global_position,
#		target_global_position,
#		max_speed
#	)
	
