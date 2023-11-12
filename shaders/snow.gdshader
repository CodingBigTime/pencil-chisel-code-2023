shader_type spatial;

uniform sampler2D snow_albedo;
uniform sampler2D snow_normal;
uniform sampler2D snow_roughness;
uniform sampler2D dynamic_snow_mask;
uniform float uv_scale = 1.0;

void fragment() {
	vec2 uv = UV * uv_scale;
	vec3 snow_a = texture(snow_albedo, uv).rgb;
	vec3 snow_n = texture(snow_normal, uv).rgb;
	float snow_r = texture(snow_roughness, uv).r;

	float snow_mask = COLOR.r;

	ALBEDO = snow_a;
	NORMAL_MAP = snow_n;
	ROUGHNESS = snow_r;
}

void vertex() {
	float snow_mask = 1.0;
	snow_mask *= texture(dynamic_snow_mask, UV).r;
	VERTEX.y += snow_mask;
}
