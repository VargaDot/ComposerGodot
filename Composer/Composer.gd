extends Node

signal started_loading(path: String)

signal invalid_scene(path: String)
signal failed_loading(path: String)
signal updated_loading(path: String, progress: int)

signal finished_loading(scene: Resource)
signal finished_loading_for_scene()

var _loading_timer: Timer = null
var _current_loading_path: String = ""
var _current_load_settings: LoadSettings = null
var _current_load_screen: Node = null

func _ready() -> void:
	invalid_scene.connect(_on_invalid_scene)
	failed_loading.connect(_on_failed_loading)
	finished_loading.connect(_on_finished_loading)

	_setup_timer()

func load(path: String, load_settings: LoadSettings = null) -> void:
	var loader: Error = ResourceLoader.load_threaded_request(path)
	if not ResourceLoader.exists(path) or loader == null:
		invalid_scene.emit(path)
		return

	if _loading_timer == null: _setup_timer()

	if load_settings != null: _setup_load(load_settings)

	get_tree().current_scene.queue_free()

	_current_loading_path = path
	_loading_timer.start()

	started_loading.emit(_current_loading_path)

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
			finished_loading.emit(ResourceLoader.load_threaded_get(_current_loading_path))

func _setup_timer() -> void:
	_loading_timer = Timer.new()
	_loading_timer.name = "LoadingTimer"
	_loading_timer.wait_time = 0.1
	_loading_timer.timeout.connect(check_loading_status)
	get_tree().root.call_deferred("add_child",_loading_timer)

func _setup_load(load_settings: LoadSettings) -> void:
	_current_load_settings = load_settings

	_current_load_screen = load(_current_load_settings.loading_screen).instantiate()
	updated_loading.connect(Callable(_current_load_screen, _current_load_settings.load_screen_update_func))
	finished_loading.connect(Callable(_current_load_screen, _current_load_settings.load_screen_finsh_func))

	get_tree().root.call_deferred("add_child",_current_load_screen)
	get_tree().root.call_deferred("move_child",_current_load_screen, get_child_count()-1)

func _on_invalid_scene(path: String) -> void:
	printerr("Error: Invalid resource: " + path)

func _on_failed_loading(path: String) -> void:
	printerr("Error: Failed to load resource: " + path)

func _on_finished_loading(scene: PackedScene) -> void:
	var new_scene: Node = scene.instantiate()

	if _current_load_settings != null:
		new_scene.hide()
		new_scene.process_mode = Node.PROCESS_MODE_DISABLED
		finished_loading_for_scene.connect(Callable(new_scene, _current_load_settings.loaded_scene_start_func))

		if _current_load_settings.call_finished_for_scene:
			finished_loading_for_scene.emit()
			_current_load_screen.queue_free()

	get_tree().root.call_deferred("add_child", new_scene)
	get_tree().set_deferred("current_scene", new_scene)

	_current_load_settings = null
	_current_load_screen = null
	_current_loading_path = ""
