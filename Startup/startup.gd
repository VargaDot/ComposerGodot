extends Node2D

func _ready() -> void:
	set_process(false)

	if Composer.current_state != Composer.STATES.IDLE:
		await Composer.finished_initialising

	Composer.setup_load_screen("res://StartupFade/StartupFade.tscn")
	Composer.load_scene("res://Menu/menu.tscn")
