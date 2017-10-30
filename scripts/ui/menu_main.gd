
extends Node2D

onready var timer = get_tree().get_root().get_node("main/timer")
# member variables here, example:
onready var settings = get_tree().get_root().get_node("main/settings")
onready var buttons = get_node("CenterContainer/VBoxContainer")
#onready var button_snake = buttons.get_node("button_snake")
#onready var button_high_scores = buttons.get_node("button_high_scores")
#onready var button_settings = buttons.get_node("button_settings")
#onready var button_about = buttons.get_node("button_about")
#onready var button_exit = buttons.get_node("button_exit")

var first_button_position = Vector2(0,160)
var screen_size = Vector2(1280,720)
var button_spacing = Vector2(96,400)
var button_colour_normal = Color(0, 0, 0.25)
var button_colour_focus = Color(0, 0, 1)
var button = []
var current_button_value = 0

func _ready():
	timer.stop()
	var button_counter = 0

	for N in buttons.get_children():
		N.set_modulate(button_colour_normal)
		#N.set_pos(Vector2( (screen_size.x - N.get_normal_texture().get_width())/2 , ((button_counter+1)* button_spacing.x) + first_button_position.y  ))
		N.connect("mouse_enter", self, "_on_button_mouse_enter", [N])
		N.connect("mouse_exit", self, "_on_button_mouse_exit", [N])
		button.append(N)
		N.connect("pressed", self, "_on_"+N.get_name()+"_pressed")
		print("func _on_"+N.get_name()+"_pressed():")
		print("	pass")
		print("\n")
		button_counter += 1

	button[current_button_value].set_modulate(button_colour_focus)
	set_process_input(true)
	pass

func _input(event):
	button[current_button_value].set_modulate(button_colour_normal)
	if Input.is_key_pressed(KEY_UP):
		if current_button_value > 0:
			current_button_value -= 1
		else:
			current_button_value = 0
	if Input.is_key_pressed(KEY_DOWN):
		if current_button_value < button.size() -1:
			current_button_value += 1
		else:
			current_button_value = button.size() -1
	if Input.is_key_pressed(KEY_RETURN):
		print("_on_"+button[current_button_value].get_name()+"_pressed")
		call("_on_"+button[current_button_value].get_name()+"_pressed")
		pass
	button[current_button_value].set_modulate(button_colour_focus)
	pass
	
	
func _on_button_mouse_enter(N):
	button[current_button_value].set_modulate(button_colour_normal)
	N.set_modulate(button_colour_focus)
	for i in range(0, button.size() - 0):
		if button[i] == N:
			current_button_value = i
	#current_button_value = button

func _on_button_mouse_exit(N):
	N.set_modulate(button_colour_normal)

func _on_button_snake_pressed():
	var snake_game_instance = load("res://stages/stage_snake_game.tscn").instance()
	snake_game_instance.set_name("snake_game")
	get_parent().add_child(snake_game_instance)
	queue_free()

func _on_button_falling_blocks_pressed():
	var falling_blocks_game_instance = load("res://stages/stage_falling_block_game.tscn").instance()
	falling_blocks_game_instance.set_name("falling_blocks_game")
	get_parent().add_child(falling_blocks_game_instance)
	queue_free()
	pass


func _on_button_high_scores_pressed():
	pass

func _on_button_settings_pressed():
	var settings_instance = load("res://scenes/ui/menus/menu_global_settings.tscn").instance()
	settings_instance.set_name("settings")
	get_parent().add_child(settings_instance)
	queue_free()
	pass

func _on_button_about_pressed():
	set_process_input(false)
	var about_instance = load("res://scenes/ui/menus/about.tscn").instance()
	about_instance.set_name("timer_menu")
	add_child(about_instance)
	pass

func _on_button_exit_pressed():
	get_tree().quit()
	pass



