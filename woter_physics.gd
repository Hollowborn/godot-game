extends Area3D

func _on_body_entered(body):
	if body.has_method("enter_water"):
		body.enter_water()

func _on_body_exited(body):
	if body.has_method("exit_water"):
		body.exit_water()
