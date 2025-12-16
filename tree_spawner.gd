extends Node3D

@export var tree_scene = preload("res://tree.tscn") # Drag your Tree.tscn here
@export var map_size: int = 25      # How big is the map? (-40 to 40)
@export var grid_step: int = 12      # How far apart are trees roughly?
@export var jitter: float = 2.0     # How much chaos? (Keep this < grid_step/2)
@export var clear_zone_radius: float = 8.0 # Space around the center (House)

func _ready():
	spawn_forest()

func spawn_forest():
	# 1. Loop through the map in a grid pattern
	for x in range(-map_size, map_size, grid_step):
		for z in range(-map_size, map_size, grid_step):
			
			# 2. Calculate the base position
			var pos = Vector3(x, 0, z)
			
			# 3. Apply "Jitter" (Randomness)
			# This moves the tree slightly off the perfect grid line
			pos.x += randf_range(-jitter, jitter)
			pos.z += randf_range(-jitter, jitter)
			
			# 4. SAFETY CHECK: Don't spawn inside the House!
			# Assuming your house is at (0,0,0). If not, use house.global_position
			if pos.distance_to($"../ground/woter".global_position) < clear_zone_radius:
				continue # Skip this tree
			
			# 5. OPTIONAL: Random chance to skip (Open clearings)
			if randf() > 0.7: # 30% chance to leave a gap
				continue
				
			# 6. Spawn the Tree
			place_tree(pos)

func place_tree(pos: Vector3):
	var tree = tree_scene.instantiate()
	add_child(tree)
	tree.global_position = pos
	
	# Juice: Random rotation so they don't look identical
	tree.rotate_y(randf() * TAU)
	
	# Juice: Slight random scale for variety
	var s = randf_range(0.8, 1.2)
	tree.scale = Vector3(s, s, s)
