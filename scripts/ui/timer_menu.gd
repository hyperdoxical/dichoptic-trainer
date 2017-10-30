
extends Panel

onready var settings = get_tree().get_root().get_node("main/settings")
onready var buttons = get_node("buttons")
onready var timer = get_tree().get_root().get_node("main/timer")
onready var label_minute = get_node("label_minute")
onready var timer_label = get_tree().get_root().get_node("main/Game_Control")
	

var button_colour_normal = Color(0, 0, 0.25)
var button_colour_focus = Color(0, 0, 1)
var button = []
var current_button_value = 0

var minutes = 0

func _ready():
	timer.stop()
	minutes = settings.get_time_initial_value()/60

	display_minutes()

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
	

func display_minutes():
	if minutes < 9:
		label_minute.set_text(" " + str(minutes) + "  Minutes")
	else:
		label_minute.set_text("" + str(minutes) + "  Minutes")

func _on_button_mouse_enter(N):
	button[current_button_value].set_modulate(button_colour_normal)
	N.set_modulate(button_colour_focus)
	for i in range(0, button.size() - 0):
		if button[i] == N:
			current_button_value = i
	#current_button_value = button

func _on_button_mouse_exit(N):
	N.set_modulate(button_colour_normal)







func _on_button_minus_pressed():
	if minutes > 5:
		minutes -= 5
	display_minutes()
	pass


func _on_button_plus_pressed():
	if minutes < 60:
		minutes += 5
	display_minutes()
	pass



func _on_button_done_pressed():
	settings.set_time_initial_value(minutes*60)
	settings.set_time_remaining((minutes*60)+1)
	timer_label._on_timer_time_out()
	queue_free()
	pass


func _on_button_cancel_pressed():
	
	queue_free()
	pass



func _exit_tree():
	get_parent().set_process_input(true)
	pass



