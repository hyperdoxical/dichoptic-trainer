
extends Node2D

onready var timer = get_tree().get_root().get_node("main/timer")
onready var settings = get_tree().get_root().get_node("main/settings")

onready var canvas = get_node("canvas")
onready var panel_score = get_node("panel_score")
onready var label_high_score_value = get_node("panel_score/label_high_score_value")
onready var label_high_score_text = get_node("panel_score/label_high_score_text")
onready var label_current_score_value = get_node("panel_score/label_score_value")
onready var label_current_score_text = get_node("panel_score/label_score_text")
onready var label_game_over = get_node("panel_game_over/label_game_over")
onready var panel_game_over = get_node("panel_game_over")
onready var button_play_again = panel_game_over.get_node("CenterContainer/VBoxContainer/button_play_again")
onready var button_return_to_menu = panel_game_over.get_node("CenterContainer/VBoxContainer/button_return_to_menu")

var screen_size = Vector2(1280,720)
var game_instance_name = "snake_game"
var current_score = 0 setget set_current_score , get_current_score
var high_score = 0 setget set_high_score , get_high_score

var font_score = "res://fonts/Strande2-48.fnt"
var font_game_over = "res://fonts/Strande2-48.fnt"

var button_colour_normal = Color(0, 0, 0.25)
var button_colour_focus = Color(0, 0, 1)

var button = []
var current_button_value = 0

signal current_score_changed
signal high_score_changed

var style = StyleBoxFlat.new()


func _ready():

	label_game_over.set_text("GAME OVER")
	label_game_over.set_pos(Vector2(456, 256))
	label_game_over.set("custom_fonts/font", load(font_game_over))
	
	var game_over_button_count = 0
	for N in panel_game_over.get_node("CenterContainer/VBoxContainer").get_children():
		N.set_modulate(button_colour_normal)
		#N.set_pos(Vector2( (screen_size.x - N.get_normal_texture().get_width())/2 , ((button_counter+1)* button_spacing.x) + first_button_position.y  ))
		N.connect("mouse_enter", self, "_on_button_mouse_enter", [N])
		N.connect("mouse_exit", self, "_on_button_mouse_exit", [N])
		button.append(N)
		N.connect("pressed", self, "_on_"+N.get_name()+"_pressed")
		print("func _on_"+N.get_name()+"_pressed():")
		print("	pass")
		print("\n")
		game_over_button_count += 1

	button[current_button_value].set_modulate(button_colour_focus)
	set_process_input(true)
		
	for N in panel_score.get_children():
		N.set("custom_fonts/font", load(font_score))
		N.set_scale(Vector2(0.8,0.8))
	
	label_current_score_text.set_pos(Vector2( 16, 8 ))
	label_high_score_text.set_pos(Vector2( 16, 64 ))

	label_current_score_value.set_text(str(get_current_score()))
	label_current_score_value.set_pos(Vector2( 304, 8 ))
	
	label_high_score_value.set_text(str(settings.get_high_score_snake()))
	label_high_score_value.set_pos(Vector2( 304, 64 ))
	create_game()
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



func create_game():
	set_process_input(false)
	var game_instance = load("res://scenes/games/snake_game/snake_game.tscn").instance()
	game_instance.set_field(Vector2(36,16))
	game_instance.set_field(Vector2(36,16))
	canvas.set_opacity(1)
	canvas.set_size(game_instance.get_field()*game_instance.get_unit_size())
	canvas.set_pos(Vector2( (screen_size.x - (game_instance.get_unit_size() * game_instance.get_field().x))/2.0, (screen_size.y - 2*game_instance.get_unit_size() - (game_instance.get_unit_size() * game_instance.get_field().y))))
	game_instance.set_initial_length(0)
	game_instance.set_name(game_instance_name)
	game_instance.set_pos(Vector2( (screen_size.x- game_instance.get_unit_size()*2 - (game_instance.get_unit_size() * game_instance.get_field().x))/2.0, (screen_size.y - 3*game_instance.get_unit_size() - (game_instance.get_unit_size() * game_instance.get_field().y))))
	#game_instance.set_pos(Vector2(0,32))
	set_current_score(0)
	label_current_score_value.set_text(str(get_current_score()))
	panel_game_over.hide()
	
	canvas.add_style_override("panel", style)
	style.set_bg_color(settings.get_colour_background())
	game_instance.food_colour = settings.get_colour_left_eye()
	game_instance.snake_head_colour = settings.get_colour_right_eye()
	game_instance.snake_tail_colour = settings.get_colour_right_eye()

	add_child(game_instance)
	game_instance.connect("game_over", self, "_on_game_instance_game_over", [], CONNECT_ONESHOT)
	game_instance.connect("eaten_food", self, "_on_game_instance_eaten_food")
	timer.start()

func _on_game_instance_game_over():
	#print("game over")
	set_process_input(true)
	canvas.set_opacity(0)
	yield(get_tree(), 'fixed_frame') #required to ensure previous queue is freed
	get_node(str(game_instance_name)).queue_free()
	yield(get_tree(), 'fixed_frame') #required to ensure previous queue is freed
	panel_game_over.show()
	timer.stop()
	#create_game()

func _on_game_instance_eaten_food():
	#print("eaten food")
	set_current_score(get_current_score()+1)
	label_current_score_value.set_text(str(get_current_score()))


func set_current_score(value):
	emit_signal("current_score_changed")
	if value > settings.get_high_score_snake():
		settings.set_high_score_snake(value)
		label_high_score_value.set_text(str(settings.get_high_score_snake()))
	current_score = value

func get_current_score():
	return current_score

func set_high_score(value):
	emit_signal("high_score_changed")
	high_score = value

func get_high_score():
	return high_score

func _on_button_mouse_enter(N):
	button[current_button_value].set_modulate(button_colour_normal)
	N.set_modulate(button_colour_focus)
	for i in range(0, button.size() - 0):
		if button[i] == N:
			current_button_value = i
	#current_button_value = button

func _on_button_mouse_exit(N):
	N.set_modulate(button_colour_normal)
	

func _on_button_play_again_pressed():
	create_game()
	pass



func _on_button_return_to_menu_pressed():
	var menu_instance = load("res://scenes/ui/menus/menu_main.tscn").instance()
	menu_instance.set_name("menu_main")
	get_parent().add_child(menu_instance)
	queue_free()
