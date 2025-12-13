extends Camera3D

@export var smooth_speed = 2.0
@export var offset = Vector3.ZERO

var target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Find player (Assuming single player in "player" group, or use find_first_node_in_group)
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		target = player_group[0]
		
		# In Orthographic mode, "zoom" is controlled by size, not distance.
		# But distance affects the Near Plane clipping.
		# If the camera is too close (e.g. Y=20), objects at Y=30 (clouds) will be clipped/behind.
		# We push the camera back significantly along its view axis to ensure everything is in front.
		if projection == PROJECTION_ORTHOGONAL:
			translate_object_local(Vector3(0, 0, 200)) # Move back 200 units
			
		# Use current relative position as the offset
		offset = global_position - target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Smooth Follow Logic
	if target:
		var target_pos = target.global_position + offset
		global_position = global_position.lerp(target_pos, smooth_speed * delta)
	
	if(Input.is_action_just_pressed("scroll-up")):
		if(size < 10):
			size = 10
		else:
			size -= 1.0 
	if(Input.is_action_just_pressed("scroll-down")):
		if(size > 30):
			size = 30
		else:
			size += 1.0 
	if(Input.is_action_just_pressed("scroll-click")):
		size = 15

		
