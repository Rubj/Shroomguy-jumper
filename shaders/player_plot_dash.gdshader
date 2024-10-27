shader_type canvas_item;

uniform float opacity;
uniform float r;
uniform float g;
uniform float b;
uniform float mix_color;

uniform float gradient_amount = 0.5;
uniform sampler2D gradient : hint_default_black;

void vertex() {
	
}

void fragment() {
	// It is named for each pixel in which the material is visible
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 sampled_color = texture(gradient, UV).rgb;
	
	// katsetus
	//float grayscale_value = dot(texture_color.rgb, vec3(0.299, 0.587, 0.114));
	//vec3 sampled_color = texture(gradient, vec2(grayscale_value, 0.0)).rgb;
	//
	//COLOR.rgb = mix(texture_color.rgb, sampled_color, mix_color);
	//COLOR.a = texture_color.a;
	
	if (texture_color.a != 0.0)
		COLOR = vec4(mix(texture_color.rgb, vec3(r,g,b), (sampled_color * gradient_amount) + mix_color), opacity);
}

void light() {
	// Called for each pixel of each light that affects the CanvasItem
	float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
