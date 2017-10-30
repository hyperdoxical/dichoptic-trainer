extends Node2D

##############
# How to Use #
##############

#func _on_orientation_changed(portrait):
#	if portrait:
#		print("portrait mode")
#	else:
#		print("landscape mode")
#
#
#func _ready():
#	get_node("charts").set_pos(Vector2(get_node("/root/multiscaler").minimum_size.x/2, get_node("/root/multiscaler").minimum_size.y/2))
#	get_node("/root/screen_orientation").connect("orientation_changed", self, "_on_orientation_changed")
#	pass

signal orientation_changed(portrait)
var last_size

func _ready():
	set_process(true)
	last_size = get_viewport().get_rect().size

func _process(delta):
	var size = get_viewport().get_rect().size
	if size.x != last_size.x or size.y != last_size.y:
		emit_signal("orientation_changed", size.x < size.y)
	last_size = size
