extends Node2D


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ready_screen.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ready_1.tscn")
