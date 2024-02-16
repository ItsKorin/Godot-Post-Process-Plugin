shader_type canvas_item;


uniform sampler2D noise: repeat_enable;
uniform vec4 line_color: source_color;
uniform float line_count: hint_range(0.0, 2.0, 0.05) = 2;
uniform float line_density: hint_range(0.0, 1.0) = 0.56;
uniform float line_faloff: hint_range(0.0, 1.0) = 0;
uniform float mask_size: hint_range(0.0, 1.0) = 0.333;
uniform float mask_edge: hint_range(0.0, 1.0) = 0.372;
uniform float animation_speed: hint_range(1.0, 20.0) = 20;




float inv_lerp(float from, float to, float value){
  return (value - from) / (to - from);
}




vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(PI * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}




vec2 rotate_uv(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}




void fragment(){
	vec2 polar_uv = polar_coordinates(rotate_uv(UV, vec2(0.5), floor(fract(TIME) * animation_speed) ) , vec2(0.5), 0.01, line_count);
	vec3 lines = texture(noise, polar_uv).rgb;
	
	float mask_value = length(UV - vec2(0.5));
	float mask = inv_lerp(mask_size, mask_edge, mask_value);
	float result = 1.0 - (mask * line_density);
	
	result = smoothstep(result, result + line_faloff, lines.r);
	
	COLOR.rgb = vec3(line_color.rgb);
	COLOR.a = min(line_color.a, result);
}