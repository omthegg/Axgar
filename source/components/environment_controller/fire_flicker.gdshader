shader_type canvas_item;

uniform sampler2D noise;
uniform vec3 color : source_color;

void fragment() {
	vec4 noise_texture = texture(noise, vec2(TIME, TIME));
	float light_energy = 0.05 + abs(sin(TIME*1.0))/10.0;
	COLOR = vec4(color, light_energy);
}
