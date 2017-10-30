extends Control

onready var settings = get_tree().get_root().get_node("main/settings")


onready var timer = get_tree().get_root().get_node("main/timer")
onready var timer_label = get_node("timer/label")
func _ready():
	set_anchor(MARGIN_LEFT, ANCHOR_CENTER)
	set_anchor(MARGIN_RIGHT, ANCHOR_CENTER)
	set_anchor(MARGIN_TOP, ANCHOR_CENTER)
	set_anchor(MARGIN_BOTTOM, ANCHOR_CENTER)
	timer.connect("timeout", self, "_on_timer_time_out")
	timer.set_wait_time(1)

#	get_node("Node2D").set_pos(Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2))
	pass

func _on_timer_time_out():
	settings.set_time_remaining(settings.get_time_remaining() - 1)
	if settings.get_time_remaining() > 0:
		var total_time = settings.get_time_remaining()
		var hours = 0
		var minutes = int((total_time - (hours * 3600.0)) / 60.0)
		var seconds = int(((total_time) - (hours * 3600) - (minutes * 60)))
		var str_min
		var str_sec
		if minutes > 9:
			str_min = str(minutes)
		else:
			str_min = "0" + str(minutes)
		if seconds > 9:
			str_sec = str(seconds)
		else:
			str_sec = "0" + str(seconds)
		timer_label.set_text("Session Remaining:  " + str_min + ":" + str_sec)
		
	else:
		timer_label.set_text("         Session Finished")