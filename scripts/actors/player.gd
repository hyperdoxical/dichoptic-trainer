
extends KinematicBody2D

onready var state = idleState.new(self); #self is passing the reference of the player #FlyingState.new()

#controls here
#var btn_left = input_states.new("ui_left")
#var btn_right = input_states.new("ui_right")
#var btn_jump = input_states.new("ui_up")

#Member Variables
var gravity = Vector2(0,9)
const GRAVITY = 500.0 # Pixels/second

#States
const STATE_IDLE = 0
const STATE_GROUND = 1
const STATE_AIR = 2

signal state_changed; #emitted in set_state func

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	set_process(true)

	pass

func _on_body_enter(other_body):
	if state.has_method("on_body_enter"): #ask if method has state
		state.on_body_enter(other_body)

func _on_body_exit(other_body):
	if state.has_method("on_body_exit"): #ask if method has state
		state.on_body_exit(other_body)

func _fixed_process(delta):
	state.update(delta)
	pass

func _input(event):
	state.input(event)
	pass

func set_state(new_state):
	state.exit()

	if new_state == STATE_IDLE:
		state = idleState.new(self)
	elif new_state == STATE_GROUND:
		state = groundState.new(self)
	elif new_state == STATE_AIR:
		state = airState.new(self)

	emit_signal("state_changed", self)

	pass

func get_state():
	if state extends idleState:
		return STATE_IDLE
	elif state extends groundState:
		return STATE_GROUND
	elif state extends airState:
		return STATE_AIR



####################
#######CLASSES#######
####################





####################
class idleState:
####################

	var player #required because class is out of scope of player

	func _init(player):
	#same as ready
		self.player = player #required because class is out of scope of player and has same name
		pass

	func update(delta):
	#same as fixed process
		pass

	func input(event):
#		if event.is_action_pressed("ui_left"):
#			print("left")
#			player.move(Vector2(19,0))
#		if event.is_action("ui_left"):
#			print("left")
#		if event.is_action("ui_right"):
#			print("right")
#		if self.btn_right.check() == 2:
#			print("right")
		pass

#	func on_body_enter(other_body):
#		if other_body.is_in_group(global.GROUP_LADDER):
#			ladder = true
#			print("enter")
				#player.set_state(player.STATE_LADDER);

#	func on_body_exit(other_body):
#		if other_body.is_in_group(global.GROUP_LADDER):
#			ladder = false

	func exit():
	#called automatically when changing states
#		player.get_node("anim").stop()
		pass



####################
class groundState:
####################

	var player #required because class is out of scope of player

	func _init(player):
		self.player = player #required because class is out of scope of player and has same name
		pass

	func update(delta):
		pass

	func input(event):
		pass

	func on_body_enter(other_body):
		pass

	func on_body_exit(other_body):
		pass

	func exit():
		pass



####################
class airState:
####################

	var player #required because class is out of scope of player

	func _init(player):
		self.player = player #required because class is out of scope of player and has same name
		pass

	func update(delta):
		pass

	func input(event):
		pass

	func on_body_enter(other_body):
		pass

	func on_body_exit(other_body):
		pass

	func exit():
		pass

