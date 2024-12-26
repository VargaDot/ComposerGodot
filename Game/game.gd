class_name Game extends Node2D

func on_loading_finished() -> void:
	show()
	$CanvasLayer.show()
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_game_button_pressed() -> void:
	Composer.load("res://Menu/menu.tscn")
