shader_type canvas_item;

uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 vignette_rgb : source_color = vec4(0.0, 0.0, 0.0, 1.0);

//add a color picker to inspector
uniform vec4 CAST_COLOR : source_color;
//get the underlying screen texture
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
//add a noise resource to inspector (for fast noise)
uniform sampler2D fast_noise : repeat_enable;
//speed at which waves move
uniform vec2 speed = vec2(0.03, 0.07);
//strength of waves
uniform float wave_strength = 2;
//scale and zoom parameters for when editor changes (set from script)
uniform float scale_y;
uniform float y_zoom;

float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.0;
	return pow(vignette, vignette_intensity * vignette_opacity);
}

void vertex() {
    //move water up and down
    VERTEX.y += sin(TIME) * 0.01;
}
 
void fragment() {
    //get ripple noise
    vec2 uv = UV + speed * TIME;
    
    //get the noise from fast noise
    vec2 noise = texture(fast_noise, uv).rg;
 
    //get size of object shader is on
    float uv_height = (SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y);
 
    //calc where reflection is coming from
    vec2 reflected_uv = vec2(SCREEN_UV.x, SCREEN_UV.y - (uv_height * UV.y * scale_y * y_zoom));
    
    //get reflection pixel
    vec4 reflection = texture(SCREEN_TEXTURE, reflected_uv);
    //reflect without waves
    //COLOR = reflection + CAST_COLOR
    
    //calc waves for ripples
    vec4 waves = texture(SCREEN_TEXTURE, reflected_uv + (noise - 0.5) * y_zoom * (wave_strength / 100.0));
    
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 text = texture(TEXTURE, UV);
	
	text.rgba *= (vignette_rgb.rgba);
	text.rgba *= (1.0 - vignette(UV));
	
    //apply wave ripples and selected color
    COLOR = waves + CAST_COLOR * vec4(color.rgb,text.a);

}

