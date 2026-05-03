shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D particle_texture: filter_nearest_mipmap;
uniform vec2 quad_size = vec2(1.0, 1.0);
uniform float speed = 1.0;

void vertex() {
	// Y billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec4 particle_color = texture(particle_texture, 
	vec2(UV.x * quad_size.x, UV.y * quad_size.y - TIME * speed));
	
	ALBEDO = particle_color.rgb;
	ALPHA = particle_color.a;
}
