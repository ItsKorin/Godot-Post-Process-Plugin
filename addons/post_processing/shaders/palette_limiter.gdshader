//	Godot 4 Adapt To Palette Shader
shader_type canvas_item;

uniform sampler2D palette: filter_nearest;
uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void fragment() {
	float best_diff = 4.00;
	ivec2 pal_size = textureSize(palette, 0);
	
	// Palette row scan
	for (int y = 0; y < pal_size.y; y += 1)
	{
		// Palette column scan
		for (int x = 0; x < pal_size.x; x += 1)
		{
			vec3 scr_pix = texture(screen_texture, SCREEN_UV).rgb;
			vec3 pal_pix = texelFetch(palette, ivec2(x, y), 0).rgb;
			
			// Slightly faster than distance()
			float this_diff = (
				abs(scr_pix.r - pal_pix.r) +
				abs(scr_pix.g - pal_pix.g) +
				abs(scr_pix.b - pal_pix.b));
			
			if (this_diff < best_diff)
			{
				best_diff = this_diff;
				COLOR.rgb = pal_pix.rgb;
			}
		}
	}
}