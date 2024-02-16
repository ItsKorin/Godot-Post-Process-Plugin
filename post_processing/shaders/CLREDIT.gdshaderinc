vec3 ApplyThreshold(vec3 CLR, float Threshold){
	return max(CLR - vec3(Threshold), vec3(0.0));
}

vec3 Saturation(vec3 InputCLR, float Saturation){
	return mix(vec3(dot(InputCLR.rgb, vec3(0.299, 0.587, 0.114))), InputCLR.rgb, Saturation);
}