extends Node3D

@export var cloud_scene: PackedScene
@export var cloud_count: int = 20
@export var spawn_extents: Vector3 = Vector3(200, 20, 200)

func _ready() -> void:
	if not cloud_scene:
		print("Cloud Spawner: No cloud scene assigned!")
		return
		
	for i in range(cloud_count):
		spawn_cloud()

func spawn_cloud():
	var cloud = cloud_scene.instantiate()
	add_child(cloud)
	
	# Random Position relative to spawner
	var rand_pos = Vector3(
		randf_range(-spawn_extents.x, spawn_extents.x),
		randf_range(-spawn_extents.y, spawn_extents.y),
		randf_range(-spawn_extents.z, spawn_extents.z)
	)
	
	cloud.position = rand_pos
