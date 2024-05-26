shader_type canvas_item;

uniform float first_stage : hint_range(0.0, 1.0) = 0.5; 
uniform float first_smooth : hint_range(0.0, 1.0) = 0.0; // Lengthens the color transition
uniform float second_stage : hint_range(0.0, 1.0) = 0.0;   // If left at 0, only level 1 is used.
uniform float second_smooth : hint_range(0.0, 1.0) = 0.0;
uniform float min_light : hint_range(0.0, 1.0) = 0.0;
uniform float mid_light : hint_range(0.0, 1.0) = 0.0;
uniform float max_light : hint_range(0.0, 1.0) = 1.0;
uniform float obj_light_add : hint_range(0.0, 1.0) = 0.0;

float light_calc(float light_strength, float would_be_strength) {
	float target_strength = light_strength + would_be_strength * obj_light_add;
	if (target_strength == 0.0) {target_strength = 0.000001;}
	if (would_be_strength == 0.0) {would_be_strength = 1.0;}
	return(target_strength / would_be_strength);
}

void light() {
	float level_1 = first_stage;
	float level_1_smooth = first_smooth;
	float level_2 = second_stage;
	float level_2_smooth = second_smooth;
	
	float mid_range_light = mid_light;
	if (mid_light == 0.0) { mid_range_light = max_light * 0.5; }
	vec3 light_normal = normalize(vec3(LIGHT_VEC, -LIGHT_HEIGHT));
	float would_be_strength = max(dot(-light_normal, NORMAL), 0.0);
	if (would_be_strength > level_1 && level_2 == 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength) + min_light;
		if (diff >= max_light) {diff = max_light;}
		LIGHT *= light_calc(diff, would_be_strength);
	} else if (would_be_strength > level_1 && would_be_strength < level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength) + min_light;
		if (diff >= mid_range_light ) {diff = mid_range_light;}
		LIGHT *= light_calc(diff, would_be_strength);
	} else if (would_be_strength >= level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_2, (level_2 + level_2_smooth), would_be_strength) + mid_range_light;
		if (diff < mid_range_light ) {diff = mid_range_light;}
		if (diff >= max_light) {diff = max_light;}
		LIGHT *= light_calc(diff, would_be_strength);
	} else { 
		if (min_light != 0.0) { 
			LIGHT_VEC = -NORMAL.xy*length(LIGHT_VEC); 
		}
		LIGHT *= min_light;                                                                                                                                  
	}
}