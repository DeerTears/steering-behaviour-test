extends Area2D

onready var anim_player = $AnimationPlayer
var click_down: bool = false
var in_body: bool = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fadeout":
		visible = false
		#print(visible)


func _on_body_entered(_body):
	in_body = true
	if click_down == false:
		anim_player.play("Fadeout")
		#print(visible)
	if click_down:
		wait_until_mouse_is_up()


func _on_body_exited(_body):
	in_body = false


func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")
# warning-ignore:return_value_discarded
	connect("body_exited", self, "_on_body_exited")
	visible = false


func _unhandled_input(event) -> void:
	if event.is_action_released("click"):
		click_down = false
	if event.is_action_pressed("click"):
		click_down = true
		if visible == true and anim_player.is_playing():
			anim_player.stop(true)
			anim_player.play("Skip")
		if visible == false:
			anim_player.play("Fadein")
			visible = true
		if in_body:
			wait_until_mouse_is_up()


func _process(_delta):
	if Input.is_action_pressed("click"):
		global_position = get_global_mouse_position()


func wait_until_mouse_is_up(): # ultimate edge-case function
	yield(get_tree().create_timer(0.3), "timeout")
	if in_body and (click_down == false):
		anim_player.play("Fadeout")
	elif (in_body == false) and click_down:
		return
	elif (in_body == false) and (click_down == false):
		return
	elif in_body and click_down:
		wait_until_mouse_is_up()
		print_debug("player dragged mouse on player: " + OS.get_time(false) as String)
		pass
	else:
		print_debug("oh cool you forget a check")
		pass

