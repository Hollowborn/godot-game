extends StaticBody3D

@export var log_scene = preload("res://log.tscn") # Drag your Log.tscn here
@export var health = 3



func _ready():
	print('les go!')






func take_damage():
	health -= 1
	# Juice: Shake the tree slightly when hit!
	var tween = create_tween()
	tween.tween_property($MeshInstance3D, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property($MeshInstance3D, "scale", Vector3(1.0, 1.0, 1.0), 0.1)
	
	if health <= 0:
		spawn_logs()
		queue_free()

func spawn_logs():
	for i in range(3): # Spawn 3 logs
		var log_instance = log_scene.instantiate()
		get_parent().add_child(log_instance)

		log_instance.global_position = global_position + Vector3(0, 20, 0)
		
		# Apply random explosion force so they fly out!
		var random_dir = Vector3(randf_range(-1,1), 1, randf_range(-1,1)).normalized()
		log_instance.apply_impulse(random_dir * 5.0)


func _on_mouse_entered() -> void:
	print('touche ')
	take_damage() # Replace with function body.
