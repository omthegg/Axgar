shader_type spatial;
render_mode cull_disabled;

uniform sampler2D reflection_texture;
uniform sampler2D frame_texture: filter_nearest_mipmap;

uniform vec4 reflection_tint: source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform sampler2D frame_gradient;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

vec2 panorama_uv(vec3 dir)
{
	dir = normalize(dir);
	
	float u = atan(dir.x, dir.z) / (2.0 * PI) + 0.5;
	float v = acos(clamp(dir.y, -1.0, 1.0)) / PI;
	
	return vec2(u, v);
}

void fragment() {
	vec3 view_dir = normalize(-VIEW);
	vec3 reflection_vector = reflect(view_dir, NORMAL);
	vec3 reflection_world = (INV_VIEW_MATRIX * vec4(reflection_vector, 0.0)).xyz;
	vec3 normal_dir = normalize(NORMAL);
	
	vec2 uv = panorama_uv(reflection_world);
	
	//vec2 uv = reflection_world.xy * vec2(1.0/PI, 0.5) + vec2(0.0, 0.5);
	vec4 reflection_color = texture(reflection_texture, uv);
	vec4 frame_color = texture(frame_texture, UV);
	
	vec4 gradient_color = texture(frame_gradient, rotateUV(UV, vec2(0.0, 0.0), radians(90.0)));
	
	if (frame_color.a == 0.0)
	{
		ALBEDO = reflection_color.xyz * reflection_tint.xyz;
	}
	else
	{
		ALBEDO = frame_color.xyz * gradient_color.xyz;
	}
	
	//ALBEDO = triplanar_texture(reflection_texture, uv1_power_normal, uv1_triplanar_pos).rgb;
}
