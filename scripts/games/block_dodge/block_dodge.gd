
extends Node2D

onready var player = get_node("player")
var canvas_size = Vector2(320,650)
var speed =8

func _ready():
	set_process_input(true)
	player.set_pos(Vector2(256,512))
	pass

func _input(event):
	if Input.is_key_pressed(KEY_LEFT):
		if player.get_pos().x - (speed + player.get_node("sprite").get_texture().get_width()/2) > 0:
			player.move(Vector2(-speed,0))
	if Input.is_key_pressed(KEY_RIGHT):
		if player.get_pos().x + (speed + player.get_node("sprite").get_texture().get_width()/2) < canvas_size.x:
			player.move(Vector2(speed,0))

func move_player(movement):
	if player.get_pos().x - movement.x - player.sprite.get_texture().get_width() > 0:
		player.move(movement)
	if player.get_pos().x - movement.x - player.sprite.get_texture().get_width() > 0:
		player.move(movement)

