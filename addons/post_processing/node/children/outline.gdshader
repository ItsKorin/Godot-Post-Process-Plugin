// NekotoArts YouTube: https://www.youtube.com/channel/UCD7K_FECPHTF0z5okAVlh0g
// Adapted from https://www.shadertoy.com/view/ldsfRn

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 edge_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float threshold = 0.0;
uniform float blend = 0.01;

float getGrayScale(sampler2D sampler, vec2 coods){
	vec4 color = texture(sampler,coods);
	float gray = (color.r + color.g + color.b)/3.0;
	return gray;
}

void fragment(){
	vec2 delta = vec2(0.0,0.003);
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	float m = max(iResolution.x,iResolution.y);
	vec2 texCoords = SCREEN_UV;
	
	vec3 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	float c1y = getGrayScale(SCREEN_TEXTURE, texCoords.xy-delta/2.0);
	float c2y = getGrayScale(SCREEN_TEXTURE, texCoords.xy+delta/2.0);
	
	float c1x = getGrayScale(SCREEN_TEXTURE, texCoords.xy-delta.yx/2.0);
	float c2x = getGrayScale(SCREEN_TEXTURE, texCoords.xy+delta.yx/2.0);
	
	float dcdx = (c2x - c1x)/(delta.y*10.0);
	float dcdy = (c2y - c1y)/(delta.y*10.0);
	
	vec2 dcdi = vec2(dcdx,dcdy);
	float edge = length(dcdi)/10.0;
	edge = 1.0 - edge;
	edge = smoothstep(threshold, threshold + blend, edge);
	
	COLOR.rgb = mix(edge_color.rgb, screen_color.rgb, edge);
}