shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int blur_radius : hint_range(1, 16) = 4;
uniform float blur_strength : hint_range(0.1, 32.0) = 1.0;
uniform bool vertical_pass = false;

void fragment() {
	vec2 resolution = SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	vec2 direction = vertical_pass ? vec2(0.0, 1.0) : vec2(1.0, 0.0);

	vec3 color = vec3(0.0);
	float total = 0.0;

	for (int i = -blur_radius; i <= blur_radius; i++) {
		float weight = exp(-float(i * i) / (2.0 * blur_strength));
		vec2 offset = direction * float(i) * resolution;
		color += texture(SCREEN_TEXTURE, uv + offset).rgb * weight;
		total += weight;
	}

	COLOR = vec4(color / total, 1.0);
}
