class_name LoadScreen extends Node2D

signal loading_activated

func _ready() -> void:
	Composer.updated_loading.connect(update_load_screen)
	Composer.finished_loading.connect(loading_finished)
	set_process(false)

func update_load_screen(progress: int) -> void:
	$CanvasLayer/LoadScreen/ProgressBar.value = progress
	print("Progress: ", str(progress))

func loading_finished(scene: Node) -> void:
	loading_activated.connect(scene.on_loading_activated)

	$CanvasLayer/LoadScreen/ProgressBar.value = 100
	$CanvasLayer/LoadScreen/FinishedLabel.show()
	set_process(true)
	print("Finished")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("activate"):
		loading_activated.emit()
		Composer.clear_load_screen()
