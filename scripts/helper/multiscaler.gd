#https://godotengine.org/qa/9947/responsive-to-fit-multiple-resolutions
extends Node

onready var viewport = get_viewport()

signal orientation_changed

var portrait = bool()

var minimum_size = Vector2(1280, 720)

func _ready():
	var timer_instance = Timer.new()
	timer_instance.set_name("timer_orientation_change")
	timer_instance.set_wait_time(0.1)
	add_child(timer_instance)
	timer_instance.connect("timeout", self, "_on_timer_orientation_change_timeout")
	viewport.connect("size_changed", self, "window_resize")
	window_resize()

func window_resize():
	var current_size = OS.get_window_size()
	
	#get wheter landscape or portrait and adjust minimum size accordingly

	if current_size.x < current_size.y:
		if minimum_size.x > minimum_size.y:
			minimum_size = Vector2(720, 1280)
			pass
	else: #if landscape
		if minimum_size.x < minimum_size.y:
			minimum_size = Vector2(1280, 720)
			pass



	var scale_factor = minimum_size.y/current_size.y
	var new_size = Vector2(current_size.x*scale_factor, minimum_size.y)



	if new_size.y < minimum_size.y:
		scale_factor = minimum_size.y/new_size.y
		new_size = Vector2(new_size.x*scale_factor, minimum_size.y)
	if new_size.x < minimum_size.x:
		scale_factor = minimum_size.x/new_size.x
		new_size = Vector2(minimum_size.x, new_size.y*scale_factor)
	
	get_node("timer_orientation_change").start()
#	if new_size.x > new_size.y:
#		portrait = false
#	else:
#		portrait = true

	viewport.set_size_override(true, new_size)
	#print(str(new_size) + str(current_size))


func _on_timer_orientation_change_timeout():
	get_node("timer_orientation_change").stop()
	if portrait:
		if OS.get_window_size().x > OS.get_window_size().y:
			portrait = false
			emit_signal("orientation_changed")
			#OS.set_screen_orientation(OS.SCREEN_ORIENTATION_LANDSCAPE)
	else: #if not portrait
		if OS.get_window_size().x < OS.get_window_size().y:
			portrait = true
			emit_signal("orientation_changed")
#			OS.get_screen_orientation()
#			OS.set_screen_orientation(OS.SCREEN_ORIENTATION_PORTRAIT)
	
	

