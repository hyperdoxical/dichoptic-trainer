
extends Node

# member variables here, example:
var colour_right_eye = null setget set_colour_right_eye , get_colour_right_eye
var colour_left_eye = null setget set_colour_left_eye , get_colour_left_eye
var volume_fx = null setget set_volume_fx , get_volume_fx
var volume_music = null setget set_volume_music , get_volume_music
var timer_running = null setget set_timer_running , get_timer_running
var colour_background = null setget set_colour_background , get_colour_background
var high_score_snake = null setget set_high_score_snake , get_high_score_snake
var high_score_falling_block = null setget set_high_score_falling_block , get_high_score_falling_block
var time_remaining = 60*30 setget set_time_remaining, get_time_remaining
var time_initial_value = time_remaining setget set_time_initial_value, get_time_initial_value

signal timer_running_changed
signal high_score_snake_changed


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	reset_to_default_colours()
	set_high_score_snake(0) #only for testing
	set_high_score_falling_block(0) #only for testing

	pass

func reset_to_default_colours():
	set_colour_background(Color(1,1,1))
	set_colour_left_eye(Color(0,1,0))
	set_colour_right_eye(Color(1,0,0))

func set_colour_right_eye(value):
	colour_right_eye = value

func get_colour_right_eye():
	return colour_right_eye

func set_colour_left_eye(value):
	colour_left_eye = value

func get_colour_left_eye():
	return colour_left_eye

func set_volume_fx(value):
	volume_fx = value

func get_volume_fx():
	return volume_fx

func set_volume_music(value):
	volume_music = value

func get_volume_music():
	return volume_music

func set_timer_running(value):
	emit_signal("timer_running_changed")
	timer_running = value

func get_timer_running():
	return timer_running

func set_colour_background(value):
	colour_background = value

func get_colour_background():
	return colour_background

func set_high_score_snake(value):
	emit_signal("high_score_snake_changed")
	high_score_snake = value

func get_high_score_snake():
	return high_score_snake

func set_high_score_falling_block(value):
	emit_signal("high_score_falling_block_changed")
	high_score_falling_block = value

func get_high_score_falling_block():
	return high_score_falling_block

func set_time_remaining(value):
	time_remaining = value
	pass


func get_time_remaining():
	return time_remaining
	pass

func set_time_initial_value(value):
	time_initial_value = value

func get_time_initial_value():
	return time_initial_value
