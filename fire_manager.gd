extends Area3D

@onready var light = $"../light"
@onready var particles = $"../particles"
@onready var label = $Label3D

var fire_on = true
var player_ref = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	
	# Update text to match cost
	label.text = "[E] Toggle"
	
	# Connect signals via code (or do it in editor)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(float) -> void:
	
	if player_ref and Input.is_action_just_pressed("interact"):
		toggle_lights()
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		
		# Feedback: Show the prompt
		label.visible = true
		
		# Optional: Change text color if they can't afford it
func _on_body_exited(body):
	if body == player_ref:
		player_ref = null
		label.visible = false
		
func toggle_lights():
	light.visible = !fire_on
	particles.visible = !fire_on
	fire_on = !fire_on
	print('toggled')

	
