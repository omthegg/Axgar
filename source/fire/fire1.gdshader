shader_type spatial;
render_mode unshaded;

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
	vec4 noise = texture(noise_texture, UV);
	vec4 gradient = texture(gradient_texture, rotateUV(UV, vec2(0.0, 0.0), radians(90.0)));
	ALBEDO = noise.xyz * gradient.xyz;
	ALPHA = noise.x;
}
