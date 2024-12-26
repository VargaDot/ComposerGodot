extends Node2D

@onready var loading_screen: PackedScene = preload("res://Load Screen/LoadScreen.tscn")

func _on_menu_button_pressed() -> void:
	Composer.load("res://Game/game.tscn", loading_screen)
