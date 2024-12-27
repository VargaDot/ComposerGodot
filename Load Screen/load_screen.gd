class_name LoadScreen extends Node2D

func _ready() -> void:
	Composer.updated_loading.connect(update_load_screen)
	Composer.finished_loading.connect(loading_finished)
	set_process(false)

func update_load_screen(progress: int) -> void:
	$CanvasLayer/LoadScreen/ProgressBar.value = progress
	print("Progress: ", str(progress))

func loading_finished(scene: Node) -> void:
	Composer.loading_activated.connect(scene.on_loading_activated)

	$CanvasLayer/LoadScreen/ProgressBar.value = 100
	$CanvasLayer/LoadScreen/FinishedLabel.show()
	$CanvasLayer/LoadScreen/FinishedLabel/AnimationPlayer.play("FadeInOut")
	set_process(true)
	print("Finished")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("activate"):
		Composer.loading_activated.emit()
		Composer.clear_load_screen()
