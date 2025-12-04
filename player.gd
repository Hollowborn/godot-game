extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 10.0
@export var rotation_speed = 10.0 # How fast the character turns

# Gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# 1. Apply Gravity

	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Get Input (Returns a vector between -1 and 1)
	# This naturally handles 8-way movement (Up, Down, Left, Right, and Diagonals)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 3. Calculate Direction relative to the WORLD (Global), not the Player
	# We create a Vector3 on the floor (X and Z axis).
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# 4. Adjust for Isometric Camera (Rotate 45 degrees on Y axis)
	# If your camera is rotated -45 degrees, rotate input by -45 (or 45 depending on setup).
	# Try 45 first. If controls are inverted, change to -45.
	direction = direction.rotated(Vector3.UP, deg_to_rad(45))

	if direction:
		# 5. Move Logic (Smooth acceleration)
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
		
		# 6. Rotation Logic (Smooth rotation instead of instant snapping)
		# We check if the direction is significant to avoid "looking at nothing" errors
		if Vector2(velocity.x, velocity.z).length() > 0.1:
			var current_angle = rotation.y
			var target_angle = atan2(velocity.x, velocity.z)
			# Lerp_angle handles the "wrapping" from 360 to 0 degrees smoothly
			rotation.y = lerp_angle(current_angle, target_angle, rotation_speed * delta)
			
	else:
		# Decelerate when no input
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)

	move_and_slide()
