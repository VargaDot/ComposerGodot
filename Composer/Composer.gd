extends Node

signal finished_initialising()

signal invalid_scene(path: String)
signal failed_loading(path: String)
signal updated_loading(path: String, progress: int)
signal finished_loading(scene: Node)

signal loading_activated()

var has_initialized: bool = false:
	set(val):
		has_initialized = val
		if has_initialized:
			finished_initialising.emit()

var _is_loading: bool = false

var _loading_timer: Timer = null
var _current_loading_path: String = ""
var _current_load_screen: Node = null

func _enter_tree() -> void:
	invalid_scene.connect(_on_invalid_scene)
	failed_loading.connect(_on_failed_loading)
	finished_loading.connect(_on_finished_loading)

	_setup_timer()

func load(path_to_scene: String) -> void:
	if _is_loading: return

	if !has_initialized: await finished_initialising

	var loader: Error = ResourceLoader.load_threaded_request(path_to_scene)
	if not ResourceLoader.exists(path_to_scene) or loader == null:
		invalid_scene.emit(path_to_scene)
		return

	_is_loading = true

	if _loading_timer == null: _setup_timer()

	get_tree().current_scene.queue_free()

	_current_loading_path = path_to_scene
	_loading_timer.start()

func setup_load_screen(path_to_load_screen: String) -> Node:
	_current_load_screen = load(path_to_load_screen).instantiate()

	get_tree().root.call_deferred("add_child",_current_load_screen)
	get_tree().root.call_deferred("move_child",_current_load_screen, get_child_count()-1)

	return _current_load_screen

func clear_load_screen() -> void:
	_current_load_screen.queue_free()
	_current_load_screen = null

func check_loading_status() -> void:
	var load_progress: Array = []
	var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(_current_loading_path, load_progress)

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			invalid_scene.emit(_current_loading_path)
			_loading_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_FAILED:
			failed_loading.emit(_current_loading_path)
			_loading_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			updated_loading.emit(_current_loading_path, int(load_progress[0] * 100))
		ResourceLoader.THREAD_LOAD_LOADED:
			_loading_timer.stop()
			finished_loading.emit(ResourceLoader.load_threaded_get(_current_loading_path).instantiate())

func _setup_timer() -> void:
	_loading_timer = Timer.new()
	_loading_timer.name = "LoadingTimer"
	_loading_timer.wait_time = 0.1
	_loading_timer.timeout.connect(check_loading_status)
	get_tree().root.call_deferred("add_child",_loading_timer)

	await _loading_timer.ready

	has_initialized = true

func _on_finished_loading(scene: Node) -> void:
	get_tree().root.call_deferred("add_child", scene)
	get_tree().set_deferred("current_scene", scene)

	_current_loading_path = ""
	_is_loading = false

func _on_invalid_scene(path: String) -> void:
	printerr("Error: Invalid resource: " + path)

func _on_failed_loading(path: String) -> void:
	printerr("Error: Failed to load resource: " + path)
