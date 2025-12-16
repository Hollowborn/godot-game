extends StaticBody3D

# Drag the specific mesh nodes here in the Inspector
@export var mesh_destroyed: Node3D
@export var mesh_repaired: Node3D
@export var repair_particles: GPUParticles3D # Optional: Add this later for juice!

var is_repaired = false

func _ready():
	# Initialize the state
	mesh_destroyed.visible = true
	mesh_repaired.visible = false

func upgrade_house():
	if is_repaired: return # Prevent double repairing
	
	is_repaired = true
	
	# 1. Swap Visuals
	mesh_destroyed.visible = false
	mesh_repaired.visible = true
	
	# 2. Play Juice (Optional)
	if repair_particles:
		repair_particles.emitting = true
		
	# 3. Play Sound (Create an AudioStreamPlayer3D child if you want)
	$AudioStreamPlayer.play()
	
	print("House Repaired!")
