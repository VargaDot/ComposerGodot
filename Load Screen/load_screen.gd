class_name LoadScreen extends CanvasLayer

var _scene: Node

func _ready() -> void:
	Composer.updated_loading.connect(update_load_screen)
	Composer.finished_loading.connect(loading_finished)
	set_process(false)

func update_load_screen(progress: int) -> void:
	$ProgressBar.value = progress
	print("Progress: ", str(progress))

func loading_finished(scene: Node) -> void:
	_scene = scene
	Composer.loading_activated.connect(_scene.on_loading_activated)

	$ProgressBar.value = 100
	$FinishedLabel.show()
	$FinishedLabel/AnimationPlayer.play("FadeInOut")
	set_process(true)
	print("Finished")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("activate"):
		set_process(false)
		$FinishedLabel.hide()
		Composer.loading_activated.emit()
		Composer.loading_activated.disconnect(_scene.on_loading_activated)
		Composer.clear_load_screen()
