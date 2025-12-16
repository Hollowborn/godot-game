extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 10.0
@export var rotation_speed = 10.0 

# Animation
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get('parameters/playback')
@onready var hitbox = $Hitbox

# Items/Accessories
@onready var axe_mesh = $"Model/Barbarian/Rig/Skeleton3D/1H_Axe"

# Inventory
var wood = 0
var is_moving = false

# Signals
signal wood_changed(new_amount)

# Gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_gravity = gravity
func _ready():
	add_to_group("player")
	input_ray_pickable = true 

func _physics_process(delta):
	# 1. Apply Gravity
	
	if not is_on_floor():
		velocity.y -= current_gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = speed - 0.5
	# 2. ANIMATION LOCK (The "Bonk" Priority)
	# If we are chopping, stop moving and don't read inputs
	var current_state = state_machine.get_current_node()
	#if current_state == "chop":
		## Decelerate quickly to a stop
		#velocity.x = move_toward(velocity.x, 0, acceleration * delta * 2)
		#velocity.z = move_toward(velocity.z, 0, acceleration * delta * 2)
		#move_and_slide()
#
		#return # Stop here! Do not run movement logic below.

	# 3. MOVEMENT INPUT (Manual Control Only)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# Rotate input 45 degrees for Isometric view
	direction = direction.rotated(Vector3.UP, deg_to_rad(45))
	
	# Attack Input
	
		# We don't return here; the next frame's physics_process will catch the "chop" state lock above.

	# Velocity Calculation
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
		
		# Smooth Rotation
		if Vector2(velocity.x, velocity.z).length() > 0.1:
			var current_angle = rotation.y
			var target_angle = atan2(velocity.x, velocity.z)
			rotation.y = lerp_angle(current_angle, target_angle, rotation_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	
	# Safety net for falling off map
	if position.y < -10:
		position.y = 10
	
	move_and_slide()
	
	# 4. Handle Animation State
	handle_animation()

func toggle_weapon():
	axe_mesh.visible = !axe_mesh.visible

func start_attack():
	# Don't restart if already chopping
	if state_machine.get_current_node() == "chop": return

	state_machine.travel("chop")
	
	# Wait for the swing to hit the ground (Adjust 0.2 to match your animation)
	await get_tree().create_timer(1).timeout 
	
	# Check if we are still chopping (in case animation was cancelled)
	#if state_machine.get_current_node() == "chop":
		# Hitbox Area Logic
	var bodies = hitbox.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage()
				# Optional: Add "juice" here like screen shake
	
func handle_animation():
	# If we are doing an action (Chop), do not interfere
	
		
	# Simple Movement State Switching
	if Input.is_action_just_pressed("attack"):
		start_attack()
	elif velocity.length() > 0.1:
		# If you have a separate run/walk, you can check speed here
		# For now, just "run"
		state_machine.travel("walk")
		
	else:
		state_machine.travel("idle")

func add_wood(amount):
	wood += amount
	$log_land.play()
	wood_changed.emit(wood)

func _on_mouse_entered() -> void:
	print('hovered')
	
func enter_water():
	# Make gravity negative so he floats up slightly, or just low to sink slowly
	current_gravity = -2.0 
	# Optional: Slow him down
	speed = 2.0

func exit_water():
	current_gravity = gravity
	speed = 5.0 # Reset to your normal speed	


func _on_woterphysics_body_entered(body: Node3D) -> void:
	enter_water() # Replace with function body.


func _on_woterphysics_body_exited(body: Node3D) -> void:
	exit_water() # Replace with function body.
