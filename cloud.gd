extends Node3D

@export var move_speed: float = 2.0
@export var random_speed_variation: float = 1.0
@export var bob_speed: float = 0.5
@export var bob_amplitude: float = 0.5
@export var limit_x: float = 100.0 # Distance from start to reset
@export var reset_x: float = -50.0 # Where to reset to

var start_pos: Vector3
var current_speed: float
var time_offset: float

func _ready() -> void:
	start_pos = position
	# Randomize properties for variety
	current_speed = move_speed + randf_range(-random_speed_variation, random_speed_variation)
	time_offset = randf() * 100.0
	
	# Random scale for variety
	var s = randf_range(0.8, 1.5)
	scale = Vector3(s, s, s)

func _process(delta: float) -> void:
	# Horizontal Movement
	position.x += current_speed * delta
	
	# Vertical Bobbing (Sine wave)
	position.y = start_pos.y + sin((Time.get_ticks_msec() / 1000.0 * bob_speed) + time_offset) * bob_amplitude
	
	# Screen Wrapping (Reset if too far)
	if position.x > start_pos.x + limit_x:
		position.x = start_pos.x + reset_x
