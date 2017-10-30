
extends Node2D

onready var settings = get_tree().get_root().get_node("main/settings")
onready var buttons = get_node("CenterContainer/VBoxContainer")
onready var timer = get_tree().get_root().get_node("main/timer")
	

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




func _on_button_right_eye_colour_pressed():
	var right_eye_colour_picker_instance = load("res://scenes/ui/colour_picker.tscn").instance()
	right_eye_colour_picker_instance.set_name("right_eye_colour_picker")
	add_child(right_eye_colour_picker_instance)
	right_eye_colour_picker_instance.colour_picker.set_color(settings.get_colour_right_eye())
	right_eye_colour_picker_instance.connect("button_done_pressed", self, "_on_right_eye_colour_chosen", [], CONNECT_ONESHOT)
	
	pass


func _on_right_eye_colour_chosen():
	settings.set_colour_right_eye(get_node("right_eye_colour_picker").colour_picker.get_color())
	get_node("right_eye_colour_picker").queue_free()


func _on_button_left_eye_colour_pressed():
	var left_eye_colour_picker_instance = load("res://scenes/ui/colour_picker.tscn").instance()
	left_eye_colour_picker_instance.set_name("left_eye_colour_picker")
	add_child(left_eye_colour_picker_instance)
	left_eye_colour_picker_instance.colour_picker.set_color(settings.get_colour_left_eye())
	left_eye_colour_picker_instance.connect("button_done_pressed", self, "_on_left_eye_colour_chosen", [], CONNECT_ONESHOT)
	
	pass


func _on_left_eye_colour_chosen():
	settings.set_colour_left_eye(get_node("left_eye_colour_picker").colour_picker.get_color())
	get_node("left_eye_colour_picker").queue_free()

func _on_button_background_colour_pressed():
	var background_colour_picker_instance = load("res://scenes/ui/colour_picker.tscn").instance()
	background_colour_picker_instance.set_name("background_colour_picker")
	background_colour_picker_instance.change_background_colour = true
	add_child(background_colour_picker_instance)
	background_colour_picker_instance.colour_picker.set_color(settings.get_colour_background())
	background_colour_picker_instance.connect("button_done_pressed", self, "_on_background_colour_chosen", [], CONNECT_ONESHOT)

	pass

func _on_background_colour_chosen():
	settings.set_colour_background(get_node("background_colour_picker").colour_picker.get_color())
	get_node("background_colour_picker").queue_free()


func _on_button_timer_pressed():
	set_process_input(false)
	var timer_menu_instance = load("res://scenes/ui/menus/timer_menu.tscn").instance()
	timer_menu_instance.set_name("timer_menu")
	add_child(timer_menu_instance)
	
	pass

func _on_button_reset_to_defaults_pressed():
	settings.reset_to_default_colours()
	pass


func _on_button_return_to_main_pressed():
	var menu_instance = load("res://scenes/ui/menus/menu_main.tscn").instance()
	menu_instance.set_name("menu_main")
	get_parent().add_child(menu_instance)
	queue_free()
	pass