shader_type spatial;
render_mode cull_disabled;

uniform sampler2D reflection_texture;
uniform sampler2D frame_texture: filter_nearest_mipmap;

uniform vec4 reflection_tint: source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform sampler2D frame_gradient;

uniform sampler2D shatter_atlas: filter_nearest;
//uniform int atlas_frame_count = 0;
uniform int atlas_dimension = 8;
//uniform int atlas_pixel_dimension = 1024;

uniform int current_shatter_frame = 0;

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

vec2 get_uv_from_frame_number(vec2 uv)
{
	//int frames = atlas_frame_count;
	float n = float(current_shatter_frame + 1);
	float w = float(atlas_dimension);
	float h = float(atlas_dimension);
	
	float x = mod(n, w) - 1.0;
	float y = ceil(n/w) - 1.0;
	
	//float p = float(atlas_pixel_dimension);
	float u = x/w + uv.x/w;
	float v = y/h + uv.y/h;
	
	return vec2(u, v);
}

void fragment() {
	vec3 view_dir = normalize(-VIEW);
	vec3 reflection_vector = reflect(view_dir, NORMAL);
	vec3 reflection_world = (INV_VIEW_MATRIX * vec4(reflection_vector, 0.0)).xyz;
	//vec3 normal_dir = normalize(NORMAL);
	
	vec2 uv = panorama_uv(reflection_world);
	
	//vec2 uv = reflection_world.xy * vec2(1.0/PI, 0.5) + vec2(0.0, 0.5);
	vec4 reflection_color = texture(reflection_texture, uv);
	vec4 frame_color = texture(frame_texture, UV);
	
	vec4 gradient_color = texture(frame_gradient, rotateUV(UV, vec2(0.0, 0.0), radians(90.0)));
	
	vec4 shatter_color = round(texture(shatter_atlas, get_uv_from_frame_number(UV)));
	
	if (frame_color.a == 0.0)
	{
		//ALBEDO = shatter_color.xyz;
		ALBEDO = reflection_color.xyz * reflection_tint.xyz * shatter_color.xyz;
		ALPHA_SCISSOR_THRESHOLD = 0.5;
		ALPHA = shatter_color.r;
	}
	else
	{
		ALBEDO = frame_color.xyz * gradient_color.xyz;
	}
	
	//ALBEDO = triplanar_texture(reflection_texture, uv1_power_normal, uv1_triplanar_pos).rgb;
}
