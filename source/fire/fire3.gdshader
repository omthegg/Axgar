shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D noise_texture: filter_nearest_mipmap;
uniform sampler2D gradient_texture: filter_nearest_mipmap;


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}


void fragment() {
	vec4 noise = texture(noise_texture, UV + vec2(0.0, TIME));
	vec4 gradient = texture(gradient_texture, rotateUV(UV, vec2(0.0, 0.0), radians(90.0)));
	ALBEDO = noise.xyz * gradient.xyz;
	//ALPHA = noise.x * 3.0;
	if (noise.x < 0.3)
	{
		ALPHA = 0.0;
	}
}


void vertex()
{
	//VERTEX.y += 1.0;
	VERTEX.xz *= (VERTEX.y - 3.0)/4.0;
	VERTEX.x += sin(float(VERTEX.y + 1.0) * TIME * 8.0)/20.0;
	VERTEX.z += cos(float(VERTEX.y + 1.0) * TIME * 8.0)/20.0;
}