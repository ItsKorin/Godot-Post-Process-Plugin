shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform vec4 tint : source_color = vec4(1, 1, 1, 1);
uniform float brightness : hint_range(-1.0, 1.0) = 0;
uniform float saturation : hint_range(-1.0, 1.0) = 0;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 final_col = color * tint;
	final_col.rgb = final_col.rgb + brightness;
	
	float avg_col = (final_col.r + final_col.g + final_col.b) / 3.0;
	vec3 sat_color = mix(vec3(avg_col), final_col.rgb, 1.0 + saturation);
	
	final_col.rgb = clamp(sat_color, 0.0, 1.0);
	
	COLOR = final_col;
}