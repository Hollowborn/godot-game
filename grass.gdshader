shader_type spatial;
// specular_schlick_ggx is the standard lighting mode that allows reflections
render_mode specular_schlick_ggx;

// SETTINGS
uniform vec3 water_color : source_color = vec3(0.0, 0.4, 0.8); // Blue
uniform float wave_height : hint_range(0.0, 1.0) = 0.1;        // How bumpy?
uniform float wave_speed : hint_range(0.0, 5.0) = 2.0;         // How fast?

void vertex() {
	// Simple Sine Wave logic to make the water bob up and down
	// We combine X and Z to make it look less like a rolling sheet
	float height = sin(VERTEX.x + TIME * wave_speed) * wave_height;
	height += cos(VERTEX.z + TIME * wave_speed * 0.5) * wave_height;
	
	VERTEX.y += height;
}

void fragment() {
	ALBEDO = water_color;
	
	// THE REFLECTION MAGIC
	// Metallic: 0.0 = Plastic, 1.0 = Metal/Mirror. Water is usually low, but we hack it higher for style.
	METALLIC = 0.5; 
	
	// Roughness: 0.0 = Perfect Mirror, 1.0 = Matte. Keep this low for sharp reflections.
	ROUGHNESS = 0.1;
	
	// Transparency
	ALPHA = 0.85;
}