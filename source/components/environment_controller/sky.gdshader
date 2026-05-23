shader_type sky;

uniform vec3 sky_color: source_color;
uniform sampler2D cloud_noise_texture: filter_nearest;
uniform float wind_speed = 0.0;

void sky()
{
	vec2 sky_uv = EYEDIR.xz / EYEDIR.y;
	vec4 cloud_color = texture(cloud_noise_texture, sky_uv / 4.0 + vec2(wind_speed * TIME, wind_speed * TIME));
	
	if (EYEDIR.y > 0.0)
	{
		COLOR = cloud_color.xyz;
	}
	else
	{
		COLOR = sky_color;
	}
}
