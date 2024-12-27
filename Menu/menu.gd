extends Node2D

@onready var load_screen: String = "res://Load Screen/LoadScreen.tscn"
@onready var fade_load_screen: String = "res://LoadScreenFade/FadeLoadScreen.tscn"

var loading_screen: Node

func _on_menu_button_pressed() -> void:
	loading_screen = Composer.setup_load_screen(load_screen)
	Composer.load("res://Game/game.tscn")


func _on_fade_menu_button_pressed() -> void:
	loading_screen = Composer.setup_load_screen(fade_load_screen)
	await loading_screen.finished_fade_in
	Composer.load("res://Game/game.tscn")
