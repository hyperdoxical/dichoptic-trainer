extends Control

func _ready():

#	get_viewport().connect("size_changed", self, "window_resize")

	var sprite = Sprite.new()
	sprite.set_texture(load("res://sprites/backgrounds/global_background.png"))
	sprite.set_name("global_background")
	sprite.set_opacity(0)
	add_child(sprite)
	set_anchor(MARGIN_LEFT, ANCHOR_CENTER)
	set_anchor(MARGIN_RIGHT, ANCHOR_CENTER)
	set_anchor(MARGIN_TOP, ANCHOR_CENTER)
	set_anchor(MARGIN_BOTTOM, ANCHOR_CENTER)
	set_pos(Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2))
	pass
