shader_type canvas_item;
// set max strength to your liking here=20.0, step_size=0.1
uniform float strength:hint_range(0, 159.0, 0.1)=75;

void fragment() {
	
	// Screen Color
    vec4 screen = texture(TEXTURE, SCREEN_UV);
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
    
	// Random noise
    float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * (TIME * 10.0);
	// Add grain to Screen
	screen = screen+vec4(mod((mod(x, 13.0) ) * (mod(x, 123.0) ), 0.01)-0.005) * strength;
    
    screen = 1.0 - screen;
	COLOR = screen;
    
}