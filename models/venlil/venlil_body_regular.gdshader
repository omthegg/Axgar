shader_type spatial;

uniform sampler2D noise;
uniform vec3 color: source_color;

void fragment()
{
	vec4 noise_texture = texture(noise, UV);
	ALBEDO = (noise_texture.xyz + vec3(0.5, 0.5, 0.5)) * color;
}