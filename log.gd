extends RigidBody3D

func _ready():
	contact_monitor = true
	max_contacts_reported = 1

func _physics_process(delta):
	# Optional: Add simple logic to verify it exists
	pass

func _on_body_entered(body):
	if body.has_method("add_wood"):
		body.add_wood(1)
		queue_free()
