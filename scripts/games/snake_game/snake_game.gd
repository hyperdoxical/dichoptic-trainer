
extends Node2D

var snake = []#[Vector2(1,1), Vector2(2,1), Vector2(3,1), Vector2(4,1), Vector2(5,1)]
var food = Vector2()
var step = 0
var game_over = false
var font
var font_size = 16
var unit_size = 32
var initial_length = 9 setget set_initial_length , get_initial_length
var snake_speed = 0.25

var food_colour = Color(1,1,0) setget set_food_colour , get_food_colour
var snake_head_colour = Color(1,0,1) setget set_snake_head_colour , get_snake_head_colour
var snake_tail_colour = Color(0,0,1) setget set_snake_tail_colour , get_snake_tail_colour
var border_colour = Color(0,0,0) setget set_border_colour , get_border_colour


var field = Vector2(32,18) setget set_field , get_field #dimension of the playing field in units
var field_offset = Vector2(0,0) #position of top left corner

var up = Vector2(0,-1)
var right = Vector2(1,0)
var left = Vector2(-1,0)
var down = Vector2(0,1)

signal game_over
signal eaten_food

var direction = down

func _ready():
	
#	OS.set_window_size(field_offset*2+field*unit_size)
#	yield(get_tree(), 'fixed_frame')
#	print(OS.get_window_size())
#	OS.set_window_size(Vector2( int(OS.get_window_size().x/unit_size)*unit_size,int(OS.get_window_size().y/unit_size)*unit_size))

	var centre_factor = Vector2() #used to keep the starting point in a discrete unit rather than half way between 2
	if int(field.x) % 2 == 0: #if even
		centre_factor.x = 0.5
	else: # if odd
		centre_factor.x = 0
	if int(field.y) % 2 == 0: #if even
		centre_factor.y = 0.5
	else: # if odd
		centre_factor.y = 0
	
	field = Vector2(field.x+1, field.y+1) # takes into account borders (3 = 4 remember so we need 4+1 as we lose 2 units for left/right borders and top/bottom
	
	#snake = [Vector2(((field.x/2) + centre_factor.x + field_offset.x),field_offset.y+1), Vector2(((field.x/2) + centre_factor.x + field_offset.x)+1,field_offset.y+1)]
	
	if initial_length > field.x/2:
		initial_length = int(field.x/2)
	for i in range(0, initial_length):
		snake.append(Vector2(((field.x/2) + centre_factor.x + field_offset.x + i),field_offset.y+1))
	
	#draw the border
	
	

	font = load("res://fonts/Ubuntu-C-48.fnt")
	set_process_input(true)
	set_fixed_process(true)

func move_snake(direction):
	if snake.count(snake[0]+direction) == 0 and (snake[0].x+direction.x) > field_offset.x and ((snake[0].x+direction.x) < field_offset.x + field.x):
		if (snake[0].y+direction.y) > field_offset.y and ((snake[0].y+direction.y) < field_offset.y + field.y):
			snake.push_front(snake[0]+direction)
			snake.pop_back()
		else:
			game_over = true
	else:
		game_over = true

func _input(event):
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction = up
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction = right
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction = left
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction = down
	if Input.is_key_pressed(KEY_ESCAPE):
		game_over = true
		#get_tree().call_deferred("quit")

func spawn_food():
	if food == Vector2(0,0):
		randomize()
		#print("spawn food")
		#feed = Vector2(int(rand_range(2, 40))*font_size-font_size/2, int(rand_range(2,30))*font_size-font_size/2)
		food = Vector2(int(rand_range(field_offset.x+1, field_offset.x + field.x))*unit_size/1, int(rand_range(field_offset.y+1, field_offset.y + field.y))*unit_size/1)
	if food == Vector2(snake[0].x*unit_size/1, snake[0].y*unit_size/1):
		#snake.push_front(snake[0]+direction) adds to the front
		snake.push_back(snake[snake.size()-1]+direction) #adds to back (doesn't force you into a wall if food is next to it
		food = Vector2(0,0)
		emit_signal("eaten_food")

func _fixed_process(delta):
	step = step + delta
	if (step > snake_speed): #sets the speed of movement
		spawn_food()
		if direction == down and game_over == false:
			move_snake(down)
		elif direction == up and game_over == false:
			move_snake(up)
		elif direction == left and game_over == false:
			move_snake(left)
		elif direction == right and game_over == false:
			move_snake(right)
		step = 0
	update()

func _draw():
	
	#draw the border
	draw_rect(Rect2(Vector2(field_offset.x*unit_size,field_offset.y*unit_size),Vector2(field.x*unit_size,unit_size) ), Color(border_colour))
	
	draw_rect(Rect2(Vector2(field_offset.x*unit_size,field_offset.y*unit_size),Vector2(unit_size,field.y*unit_size) ), Color(border_colour))

	draw_rect(Rect2(Vector2(field.x*unit_size+field_offset.x*unit_size,field_offset.y*unit_size),Vector2(unit_size,(field.y+1)*unit_size) ), Color(border_colour))

	draw_rect(Rect2(Vector2(field_offset.x*unit_size,field_offset.y*unit_size+field.y*unit_size),Vector2(field.x*unit_size,unit_size) ), Color(border_colour))
	#+field.x*unit_size

	
	
	#draw_string(font, Vector2(feed), "0", Color(1,1,1))
	if food != Vector2(0,0):
		draw_rect(Rect2(Vector2(food),Vector2(unit_size,unit_size) ), Color(food_colour))
	for i in range (0,snake.size()):
		draw_rect(Rect2(Vector2(snake[i].x*unit_size/1, snake[i].y*unit_size/1 ), Vector2(unit_size,unit_size )), Color(snake_tail_colour))
		#draw_string(font, Vector2(snake[i].x*font_size-font_size/2, snake[i].y*font_size-font_size/2), "#", Color(0,0,1))
	#draw the snake's head a different colour
	draw_rect(Rect2(Vector2(snake[0].x*unit_size/1,(snake[0].y*unit_size/1)),Vector2(unit_size,unit_size) ), Color(snake_head_colour))
	if game_over == false:
		pass
		#draw_string(font, Vector2(300,20), "Snake: " + str(snake.size()), Color(1,0,0))
	else:
		#draw_string(font, Vector2((field.x*unit_size+field_offset.x*unit_size)/2,(field.y*unit_size+field_offset.y*unit_size)/2), "GAME OVER: " +  "Snake: " + str(snake.size()), Color(1,0,0))
		#draw_string(font, Vector2((field.x*unit_size+field_offset.x*unit_size-(font_size*0))/2,(field.y*unit_size+field_offset.y*unit_size)/2), "GAME OVER", Color(1,0,0))
		emit_signal("game_over")

func set_field(value):
	field = value

func get_field():
	return field

func set_unit_size(value):
	unit_size = value

func get_unit_size():
	return unit_size

func set_initial_length(value):
	if value < 2: # prevents automatic death on first "growth" if length = 1
		value = 2
	initial_length = value

func get_initial_length():
	return initial_length

func set_food_colour(value):
	food_colour = value

func get_food_colour():
	return food_colour

func set_snake_tail_colour(value):
	snake_tail_colour = value

func get_snake_tail_colour():
	return snake_tail_colour

func set_snake_head_colour(value):
	snake_head_colour = value

func get_snake_head_colour():
	return snake_head_colour

func set_border_colour(value):
	border_colour = value

func get_border_colour():
	return border_colour




