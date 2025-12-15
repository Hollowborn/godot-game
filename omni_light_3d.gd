extends OmniLight3D

@onready var noise = FastNoiseLite.new()
var time_passed = 0.0

func _process(delta):
	time_passed += delta * 20.0 # Speed of flicker
	# Sample noise to get a random smooth value between 0.8 and 1.2
	var random_energy = 1.0 + (noise.get_noise_1d(time_passed) * 0.2)
	light_energy = random_energy
