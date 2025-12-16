extends StaticBody3D

@export var log_scene = preload("res://log.tscn")
@export var health = 3

@onready var collision_shape = $CollisionShape3D # Make sure you have this naming correct!
@onready var mesh = $MeshInstance3D

func take_damage():
	health -= 1
	$tree_hit.play()
	if health <= 0:
		fall_and_die()
		$tree_impact.play() # New function for the death sequence
	else:
		# The standard "Hurt" wobble
		
		var tween = create_tween()
		tween.tween_property(mesh, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
		tween.tween_property(mesh, "scale", Vector3(1.0, 1.0, 1.0), 0.1)

func fall_and_die():
	# 1. Disable collision immediately so the player doesn't get stuck
	collision_shape.set_deferred("disabled", true)
	
	# 2. Animate the fall
	var tween = create_tween()
	# Rotate 90 degrees (PI/2) on X or Z axis to tip over
	# We use set_trans(Tween.TRANS_BOUNCE) to make it hit the ground with a thud
	tween.tween_property(mesh, "rotation:x", deg_to_rad(90), 0.8).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# 3. Wait for animation to finish
	await tween.finished
	
	# 4. NOW spawn the logs and disappear
	
	spawn_logs()
	
	queue_free()

func spawn_logs():
	for i in range(3):
		var log_instance = log_scene.instantiate()
		$log_land.play()
		get_parent().add_child(log_instance)
		
		# Adjusted height to 2.0 (approx bear head height)
		log_instance.global_position = global_position + Vector3(0, 2.0, 0)
	
		# Apply random explosion force
		var random_dir = Vector3(randf_range(-1,1), 1, randf_range(-1,1)).normalized()
		log_instance.apply_impulse(random_dir * 5.0)	
