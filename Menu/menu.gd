extends Node2D

@onready var load_screen: String = "res://Load Screen/LoadScreen.tscn"
var load_settings: LoadSettings

func _ready() -> void:
	load_settings = LoadSettings.new()
	load_settings.loading_screen = load_screen
	load_settings.load_screen_update_func = "update_load_screen"
	load_settings.load_screen_finsh_func = "loading_finished"
	load_settings.loaded_scene_start_func = "on_loading_finished"


func _on_menu_button_pressed() -> void:
	Composer.load("res://Game/game.tscn", load_settings)
