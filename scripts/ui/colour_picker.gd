
extends Node2D

onready var settings = get_tree().get_root().get_node("main/settings")

onready var colour_picker = get_node("background/colourpicker")

onready var background = get_node("background")


onready var buttons = background.get_node("HBoxContainer")
onready var button_done = buttons.get_node("button_done")
onready var button_cancel = buttons.get_node("button_cancel")
onready var canvas_example = get_node("canvas_example")
onready var object_example = canvas_example.get_node("object_example")

var style_canvas = StyleBoxFlat.new()
var style_object = StyleBoxFlat.new()

var exiting = false
var portrait_mode = bool()

var button_colour_normal = Color(0, 0, 0.25)
var button_colour_focus = Color(0, 0, 1)
var button = []
var current_button_value = 0
var change_background_colour = false

signal button_done_pressed


func _ready():

	
	
	#colour_picker.set_edit_alpha(false)
	colour_picker.set_raw_mode(false)
	#colour_picker.set_size(colour_picker.get_size()*2)
	colour_picker.set_scale(Vector2(1.53125,1.53125))
	background.set_size(Vector2(512, 720))#colour_picker.get_size())
	colour_picker.set_pos(Vector2( (background.get_size().x - colour_picker.get_size().x*colour_picker.get_scale().x)/2  ,  16))
	#background.set_pos(colour_picker.get_pos())
	#colour_picker.add_preset (Color(1,1,1,1))
	#colour_picker.add_preset (Color(1,0,0,1))
	#colour_picker.add_preset (Color(0,1,0,1))
	
	button_done.set_pos(Vector2(0+28, background.get_size().y-48))
	button_cancel.set_pos(Vector2(256+28, background.get_size().y-48))

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
	colour_picker.connect("color_changed", self, "_on_color_changed")
	#set_fixed_process(true)
	yield(get_tree(), "fixed_frame")
	canvas_example.add_style_override("panel", style_canvas)
	style_canvas.set_bg_color(settings.get_colour_background())
	object_example.add_style_override("panel", style_object)
	style_object.set_bg_color(colour_picker.get_color())

	
	

	
	pass

func _fixed_process(delta):
	object_example.add_style_override("panel", style_object)
	style_object.set_bg_color(colour_picker.get_color())

func _on_orientation_changed(portrait):

	if portrait:
		portrait_mode = true

		
	else:
		
		
		portrait_mode = false


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		yield(get_tree(), 'fixed_frame')
		if exiting == false:
			exiting = true
			queue_free()


func _input(event):
	button[current_button_value].set_modulate(button_colour_normal)
	if Input.is_key_pressed(KEY_LEFT):
		if current_button_value > 0:
			current_button_value -= 1
		else:
			current_button_value = 0
	if Input.is_key_pressed(KEY_RIGHT):
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


func _on_button_cancel_pressed():
	if exiting == false:
		exiting = true
		queue_free()

func _on_button_done_pressed():
	emit_signal("button_done_pressed")
	
	
func _on_color_changed(colour):
	if change_background_colour == false:
		object_example.add_style_override("panel", style_object)
		style_object.set_bg_color(colour)
	else:
		canvas_example.add_style_override("panel", style_canvas)
		style_canvas.set_bg_color(colour)

