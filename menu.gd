extends Control

func _on_v_box_container_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")


func _on_v_box_container_options_button_pressed() -> void:
	print("Options menu not implemented yet") 


func _on_v_box_container_exit_button_pressed() -> void:
	get_tree().quit()
