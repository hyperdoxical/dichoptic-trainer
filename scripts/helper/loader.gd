extends Node

var _loader
var currentScene
var timeMax = 100
var isLoading = false

func _ready():
	if get_node("main/Game_Control"):
		currentScene = get_tree().get_root().get_node("main/Game_Control").get_child(0)

func goto_scene(path):
	isLoading = true
#	get_node("Anim").play("close")
#	yield(get_node("Anim"), "finished")
	_loader = ResourceLoader.load_interactive(path)
	if _loader == null:
#		get_node("Anim").play_backwards("close")
		return
	set_process(true)
	currentScene.queue_free()

func _process(delta):
	if _loader == null:
		set_process(false)
		return

	var t = OS.get_ticks_ms()
	while OS.get_tick_msec() < t + timeMax:
		var err = _loader.poll()
		if err == ERR_FILE_EOF:
			var resource = _loader.get_resource()
			_loader = null
			set_new_scene(resource)
			break

func set_new_scene(scene):
	isLoading = false
#	get_node("Anim").play_backwards("close")
	currentScene = scene.instance()
	get_tree().get_root().get_node("main/Game_Control").add_child(currentScene)
