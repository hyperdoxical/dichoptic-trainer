#	https://godotengine.org/qa/7980/having-trouble-creating-keyframe-animations-in-code
# Attach to the Background Node
#EXAMPLE OF USE
###############
#extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

#func _ready():
#	var timer = Timer.new()
#	timer.connect("timeout", self, "end")
#	timer.set_wait_time(0.001)
#	timer.start()
#	timer.set_name("timer")
#	timer.set_one_shot(true)
#	add_child(timer)
#	pass

#	func end():
#	var nextScene = load("res://scenes/helper/scene_transition.tscn").instance()
#	nextScene.nextScene = "res://scene1.tscn"
#	nextScene.transitionTime = 0.1
#	get_tree().get_root().get_node("main/Background_Control").add_child(nextScene)
###############

extends Node2D #needs to be node2d NOT node so it's positioned correctly

var _loader
var currentScene
var timeMax = 100
var isLoading = false
var transitionTime = 0.25
var timer = Timer.new()
var animation = Animation.new()
var animation_length = transitionTime/2
var nextScene = "res://Sprite1.tscn"

func _ready():
	animation_length = transitionTime/2
	currentScene = get_tree().get_root().get_node("main/Game_Control").get_child(0)

	#set timer
	timer.connect("timeout", self, "goto_scene", [nextScene])
	timer.set_wait_time(animation_length)

	timer.set_name("timer")
	timer.set_one_shot(true)
	timer.start()
	add_child(timer)
	
	#viewport.connect("size_changed", self, "window_resize")

	var sprite = Sprite.new()
	sprite.set_texture(load("res://sprites/backgrounds/global_background.png")) # if attached to Background control needs to be size of global_background.png
#
#	sprite.set_pos(Vector2(0, 0))
	sprite.set_opacity(0.0)
	sprite.set_centered(true)
	sprite.set_z(10)
	sprite.set_name("sprite_transition") # Will be needed for the track path later
	add_child(sprite)
	
#	var animation = Animation.new()
	animation.set_length(animation_length)
#	animation.set_name("fade")

	animation.add_track(Animation.TYPE_VALUE)
#	animation.add_track(Animation.TYPE_TRANSFORM)
	animation.track_set_path(0, "sprite_transition:visibility/opacity")
	animation.track_set_interpolation_type (0, Animation.INTERPOLATION_LINEAR )
	animation.track_insert_key(0, 0, 0)
	animation.track_insert_key(0, animation_length, 1.0)

	
	var animationPlayer = AnimationPlayer.new()
	animationPlayer.set_name("AnimPlayer")
	add_child(animationPlayer)
	
#	animation_player.add_animation("fade", animation)
#	animation_player.play("Test")

	get_node("AnimPlayer").add_animation("fade", animation)
	get_node("AnimPlayer").play("fade")
	
	pass


func transition():
#	get_node("timer").disconnect("timeout" , self, "queue_free")
	get_node("timer").set_wait_time(animation_length)
	get_node("AnimPlayer").play_backwards("fade")
	get_node("timer").connect("timeout", self, "queue_free")
	get_node("timer").start()
	

func goto_scene(path):
	isLoading = true
#	get_node("Anim").play("close")
#	yield(get_node("Anim"), "finished")
#	print("setting scene")
	_loader = ResourceLoader.load_interactive(path)
	if _loader == null:
#		get_node("Anim").play_backwards("close")
		return
	set_process(true)
#	print("setting scene")
#	currentScene.queue_free()

func _process(delta):
	if _loader == null:
		set_process(false)
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + timeMax and get_node("timer").is_active():
		var err = _loader.poll()
		if err == ERR_FILE_EOF:
			var resource = _loader.get_resource()
			_loader = null
			currentScene.queue_free()
			set_new_scene(resource)
			transition()
			break

func set_new_scene(scene):
	isLoading = false
#	get_node("Anim").play_backwards("close")
	currentScene = scene.instance()
	get_tree().get_root().get_node("main/Game_Control").add_child(currentScene)
