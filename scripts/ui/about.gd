
extends Panel
onready var button_done = get_node("button_done")
var button_colour_normal = Color(0, 0, 0.25)
var button_colour_focus = Color(0, 0, 1)
# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	button_done.connect("mouse_enter", self, "_on_button_done_mouse_enter")
	button_done.connect("mouse_exit", self, "_on_button_done_mouse_exit")
	button_done.connect("pressed", self, "_on_button_done_pressed")
	pass

func _on_button_done_mouse_exit():
	button_done.set_modulate(button_colour_normal)

func _on_button_done_mouse_enter():
	button_done.set_modulate(button_colour_focus)

func _on_button_done_pressed():
	get_parent().set_process_input(true)
	queue_free()
