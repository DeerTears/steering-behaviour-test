extends Node

const DEFAULT_MASS = 40.0
const DEFAULT_MAX_SPEED = 400.0
const DEFAULT_SLOW_RADIUS = 200.0

export var onjump: bool = false

var airborne: bool = false

static func follow(
	velocity: Vector2,
	global_position: Vector2,
	target_position: Vector2,
	max_speed = DEFAULT_MAX_SPEED,
	mass = DEFAULT_MASS
	) -> Vector2:
	var desired_velocity = (target_position - global_position).normalized() * max_speed
	var steering = (desired_velocity - velocity) / mass
	# as you increase mass, steering vector becomes shorter
	return velocity + steering

static func arrive_to(
	velocity: Vector2,
	global_position: Vector2,
	target_position: Vector2,
	max_speed = DEFAULT_MAX_SPEED,
	slow_radius = DEFAULT_SLOW_RADIUS,
	mass = DEFAULT_MASS
	) -> Vector2:
	var to_target = global_position.distance_to(target_position)
	var desired_velocity = (target_position - global_position).normalized() * max_speed
	if to_target < slow_radius:
		desired_velocity *= (to_target / slow_radius) * 0.8 + 0.2 # offset to prevent infinite divisions
	var steering = (desired_velocity - velocity) / mass
	return velocity + steering






# OLD STUFF

func rotate_sprite(_direction:Vector2):
	$Sprite.look_at(_direction)


func _input(event):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(1):
			if not airborne:
				#max_force = 0
				airborne = true
				if onjump:
					#launch("ramp")
					pass
				else:
					#launch("regular")
					pass


func _on_JumpDetector_area_entered(_area):
	onjump = true


func _on_JumpDetector_area_exited(_area):
	onjump = false


func launch(type:String):
	var pre_tween = Vector2(1,1) # todo: actually grab the sprite's scale
	if type == "ramp":
		print("helll yeah")
		var jump_seconds = 1.1
		var jump_size = Vector2.ONE + (Vector2(jump_seconds, jump_seconds) / 2)
		$TimeInAir.start(jump_seconds / 2)
		$Tween.stop($".", "scale")
		$Tween.interpolate_property($".", "scale", pre_tween, jump_size, jump_seconds, Tween.TRANS_EXPO,Tween.EASE_OUT)
		$Tween.start()
	else:
		print("ew")
		var jump_seconds = 0.5
		var jump_size = Vector2.ONE + (Vector2(jump_seconds, jump_seconds) / 2)
		$TimeInAir.start(jump_seconds)
		$Tween.stop($".", "scale")
		$Tween.interpolate_property($".", "scale", pre_tween, jump_size, jump_seconds, Tween.TRANS_EXPO,Tween.EASE_OUT)
		$Tween.start()

func _on_TimeInAir_timeout():
	land($TimeInAir.wait_time)

func land(wait_time:float):
	var pre_tween = Vector2(2,2) # todo: actually grab the sprite's scale
	$Tween.stop($".", "scale")
	$Tween.interpolate_property($".", "scale", pre_tween, Vector2.ONE, wait_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	var scale = Vector2.ONE # todo: actually grab the sprite's scale
	if scale == Vector2.ONE:
		#max_force = FORCE_SNOW
		airborne = false
