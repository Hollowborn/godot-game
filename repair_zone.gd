extends Area3D

# Configure cost for this specific repair
@export var wood_cost = 3
@onready var label = $Label3D
@onready var parent = $"../.."
# Keep track of the player
var player_ref = null


func _ready():
	# Ensure text is hidden at start
	label.visible = false
	
	# Update text to match cost
	label.text = "[E] Repair (%d Wood)" % wood_cost
	
	# Connect signals via code (or do it in editor)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	# Listen for input ONLY if player is standing here
	if player_ref and Input.is_action_just_pressed("interact"):
		attempt_repair()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		
		# Feedback: Show the prompt
		label.visible = true
		
		# Optional: Change text color if they can't afford it
		if player_ref.wood < wood_cost:
			label.modulate = Color.RED
		else:
			label.modulate = Color.WHITE

func _on_body_exited(body):
	if body == player_ref:
		player_ref = null
		label.visible = false

func attempt_repair():
	if player_ref.wood >= wood_cost:
		# 1. Pay the cost
		player_ref.wood -= wood_cost
		player_ref.wood_changed.emit(player_ref.wood)
		
		# 2. CALL THE MANAGER
		# Since this script is on the Child (Zone), get_parent() finds the HomeManager
		if parent.has_method("upgrade_house"):
			parent.upgrade_house()
		
		# 3. Disable the sign so you can't pay twice
		queue_free()
	else:
		# Feedback for not enough wood
		var original_pos = label.position
		var tween = create_tween()
		$"../../error".play()
		tween.tween_property(label, "position:x", original_pos.x + 0.1, 0.05)
		tween.tween_property(label, "position:x", original_pos.x - 0.1, 0.05)
		tween.tween_property(label, "position", original_pos, 0.05)
