shader_type spatial;
render_mode unshaded, blend_add;

uniform float points[32];
uniform int rings = 4;
uniform float height = 2.0;
uniform float error_margin = 0.1;

uniform vec3 color: source_color;
uniform sampler2D noise_texture: filter_nearest_mipmap;

// rings + 2 = number of segments
// height / (rings + 2) = length of each segment

varying vec3 uv1_triplanar_pos;

uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001);
varying vec3 uv1_power_normal;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}


vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
	return samp;
}

void vertex() {
	int segments = rings + 1;
	float segment_length = height / float(segments);
	int i = int( ( VERTEX.y + (height / 2.0) ) / (segment_length - error_margin));
	VERTEX.x += points[i];
	//VERTEX.x += VERTEX.y + (height / 2.0);
	
	vec3 normal = NORMAL;
	
	/*
	TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);
	
	BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
	BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
	BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);
	*/
	
	// UV1 Triplanar: Enabled
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

void fragment() {
	ALPHA_SCISSOR_THRESHOLD = 0.3;
	
	//vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//float randomness = texture(noise_texture, vec2(world_vertex.x, world_vertex.z)).x;
	
	//vec4 noise = texture(noise_texture, UV + vec2(0.0, TIME));
	
	//float noise_corrected = triplanar_texture(noise_texture, uv1_power_normal, uv1_triplanar_pos).x;
	//if (noise_corrected < 0.6)
	//{
	//	noise_corrected = 0.0;
	//}
	
	//ALBEDO = noise.xyz * color;
	
	vec4 albedo_tex = triplanar_texture(noise_texture, uv1_power_normal, 
	uv1_triplanar_pos + vec3(TIME, 0.0, 0.0));
	ALBEDO = albedo_tex.xyz * color * 3.0;
	ALPHA = albedo_tex.x;
	//ALPHA = noise_corrected * (color.x + color.y + color.z) / 3.0;
}
