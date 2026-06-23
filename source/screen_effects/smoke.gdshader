shader_type canvas_item;

uniform sampler2D noise: filter_nearest;
uniform float alpha = 0.0;

void fragment()
{
	vec4 noise_color = texture(noise, mod(UV + vec2(0.0, TIME * 0.5), 1.0));
	COLOR = noise_color * vec4(1.0, 1.0, 1.0, alpha);
}