extends Control

@onready var fade_load_screen: String = "res://LoadScreenFade/FadeLoadScreen.tscn"

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func on_loading_activated() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_game_button_pressed() -> void:
	var loading_screen: Node = Composer.setup_load_screen(fade_load_screen)
	await loading_screen.finished_fade_in
	Composer.load_scene("res://Menu/menu.tscn")
