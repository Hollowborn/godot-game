extends RigidBody3D

# Remove _ready() setup for contact_monitor. 
# Areas handle detection automatically without performance cost.


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("add_wood"):
		body.add_wood(1)
		
		# Optional: Add a "pop" sound or particle effect here before deleting
		queue_free() # Replace with function body.
