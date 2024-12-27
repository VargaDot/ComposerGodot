extends Node2D

func _ready() -> void:
	set_process(false)

	if not Composer.has_initialized:
		await Composer.finished_initialising

	Composer.setup_load_screen("res://StartupFade/StartupFade.tscn")
	Composer.load("res://Menu/menu.tscn")
