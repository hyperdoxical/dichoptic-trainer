extends Node2D

func _ready():
	get_viewport().connect("size_changed", self, "window_resize")
	OS.set_window_position(Vector2(0,0))
	window_resize()
	#get_tree().set_auto_accept_quit(false)
	#OS.set_window_size(Vector2(960,540))
	get_node("Background_Control/global_background").set_modulate(Color(0.15,0.15,0.16))
	pass

func window_resize():
	set_pos(Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2))
	get_node("Background_Control").set_pos(Vector2(0, 0))
	get_node("Game_Control").set_pos(Vector2(-get_node("/root/multiscaler").minimum_size.x/2, -get_node("/root/multiscaler").minimum_size.y/2))
	pass
