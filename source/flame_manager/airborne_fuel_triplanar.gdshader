shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D shape_texture: filter_nearest_mipmap;
uniform sampler2D noise_texture: filter_nearest_mipmap;
uniform sampler2D gradient_texture: filter_nearest_mipmap;
uniform bool y_billboard = true;

varying vec3 uv1_triplanar_pos;

uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001);
varying vec3 uv1_power_normal;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform vec3 color: source_color;


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


void fragment() {
	//ALPHA_SCISSOR_THRESHOLD = 0.4;
	
	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float randomness = texture(noise_texture, vec2(world_vertex.x, world_vertex.z)).x;
	
	vec4 noise = texture(noise_texture, UV + vec2(0.0, TIME));
	vec4 gradient = texture(gradient_texture, rotateUV(UV, vec2(0.0, 0.0), radians(90.0)));

	vec4 shape = texture(shape_texture, UV);
	float shape_av = (shape.x + shape.y + shape.z)/3.0;
	shape.x = shape_av;
	shape.y = shape_av;
	shape.z = shape_av;
	
	float noise_corrected = noise.x;
	if (noise_corrected < 0.6)
	{
		noise_corrected = 0.0;
	}
	//else
	//{
	//	noise_corrected = 1.0;
	//}
	
	vec4 albedo_tex = triplanar_texture(noise_texture, uv1_power_normal, 
	uv1_triplanar_pos + vec3(TIME, 0.0, 0.0));
	ALBEDO = albedo_tex.xyz * color * 2.0;
	//ALPHA = noise.x * 3.0;
	//ALPHA = shape.w * noise.x;
	//if (noise.x < 0.4)
	//{
	//	ALPHA = 0.0;
	//}
}


void vertex()
{
	/*
	if (y_billboard)
	{
		// Y billboard
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	else
	{
		// Billboard Mode: Enabled
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	*/
	
	// UV1 Triplanar: Enabled
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
	
	
	//VERTEX.y += 1.0;
	float height = VERTEX.y + 0.5;
	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//float randomness = world_vertex.x + world_vertex.z;
	float randomness = texture(noise_texture, vec2(world_vertex.x, world_vertex.z)).x * 1000.0;
	//float randomness = fract(sin(world_vertex.x + world_vertex.z) * 23949.23949);
	//VERTEX.y += sin(height * cos(VERTEX.x * VERTEX.z) * TIME)/8.0;
	//VERTEX.xz *= (VERTEX.y - 3.0)/4.0;
	
	//VERTEX.x += height * sin(float(VERTEX.y + 1.0) * TIME * 8.0 + randomness)/20.0;
	//VERTEX.z += height * cos(float(VERTEX.y + 1.0) * TIME * 8.0 + randomness)/20.0;
	//VERTEX.y += height * sin(float(VERTEX.y + 1.0) * TIME * 8.0 + randomness)/20.0;
}