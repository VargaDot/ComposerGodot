extends CanvasLayer

signal finished_fade_in

var _fade_tween: Tween
var _scene: Node

func _ready() -> void:
	set_process(false)
	load_screen_fade_in()
	Composer.finished_loading.connect(loading_finished)

func load_screen_fade_in() -> void:
	$LoadScreen/FadeRect.show()
	$LoadScreen/FadeRect.color = Color(0,0,0,0)

	_fade_tween = get_tree().create_tween()
	_fade_tween.tween_property($LoadScreen/FadeRect,"color:a",1.0,0.75)
	_fade_tween.tween_callback(func() -> void:
		_fade_tween.kill()
		finished_fade_in.emit()
	)

func load_screen_fade_out() -> void:
	$LoadScreen/FinishedLabel.hide()
	$LoadScreen/FadeRect.show()

	_fade_tween = get_tree().create_tween()
	_fade_tween.tween_property($LoadScreen/FadeRect,"color:a",0,0.75)
	_fade_tween.tween_callback(func() -> void:
		_fade_tween.kill()
		Composer.clear_load_screen()
	)

func loading_finished(scene: Node) -> void:
	_scene = scene
	Composer.loading_activated.connect(_scene.on_loading_activated)
	$LoadScreen/FinishedLabel.show()
	$LoadScreen/FinishedLabel/AnimationPlayer.play("FadeInOut")
	set_process(true)
	print("Finished")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("activate"):
		set_process(false)
		$LoadScreen/FinishedLabel.hide()
		Composer.loading_activated.emit()
		Composer.loading_activated.disconnect(_scene.on_loading_activated)
		load_screen_fade_out()
