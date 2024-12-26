class_name LoadScreen extends Node2D

func _ready() -> void:
	set_process(false)

func update_load_screen(progress: int) -> void:
	$CanvasLayer/LoadScreen/ProgressBar.value = progress
	print("Progress: ", str(progress))

func loading_finished(_scene: Resource) -> void:
	$CanvasLayer/LoadScreen/ProgressBar.value = 100
	$CanvasLayer/LoadScreen/FinishedLabel.show()
	set_process(true)
	print("Finished")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("activate"):
		Composer.finished_loading_for_scene.emit()
		queue_free()
