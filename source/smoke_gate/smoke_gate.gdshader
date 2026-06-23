shader_type spatial;

uniform vec2 size = vec2(1.0, 1.0);
uniform sampler2D noise: filter_nearest_mipmap;


void fragment() {
	ALPHA_SCISSOR_THRESHOLD = 0.3;
	vec4 color = texture(noise, UV * size * vec2(0.5, 0.5) + vec2(0.0, TIME));
	vec4 color2 = texture(noise, UV * size * vec2(1.0, 1.0) + vec2(0.0, TIME));
	ALBEDO = color.rgb * color2.rgb;
	ALPHA = color.a;
}
