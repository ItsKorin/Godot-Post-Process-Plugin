/*
	アスキー文字エフェクトシェーダー by あるる（きのもと 結衣） @arlez80
	Ascii Effect Shader by Yui Kinomoto @arlez80

	MIT License
*/

shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const vec3 MONOCHROME_SCALE = vec3( 0.298912, 0.586611, 0.114478 );

uniform sampler2D ascii_tex : source_color;
uniform vec2 ascii_size = vec2( 8.0, 16.0 );
uniform int available_columns = 10;
uniform int max_columns = 16;

void fragment( )
{
	vec2 screen_uv = floor( SCREEN_UV / SCREEN_PIXEL_SIZE / ascii_size ) * SCREEN_PIXEL_SIZE * ascii_size;
	vec2 diff = ascii_size * SCREEN_PIXEL_SIZE;
	vec4 color = (
		textureLod( SCREEN_TEXTURE, screen_uv, 0.0 )
	+	textureLod( SCREEN_TEXTURE, screen_uv + vec2( 0.0, diff.y ), 0.0 )
	+	textureLod( SCREEN_TEXTURE, screen_uv + vec2( diff.x, 0.0 ), 0.0 )
	+	textureLod( SCREEN_TEXTURE, screen_uv + diff, 0.0 )
	) / 4.0;

	vec2 ascii_uv = fract( SCREEN_UV / SCREEN_PIXEL_SIZE / ascii_size );
	ascii_uv.x = ( 1.0 - ascii_uv.x ) / float( max_columns );
	float col = floor( dot( color.rgb, MONOCHROME_SCALE ) * float( available_columns ) ) / float( available_columns );

	COLOR = texture( ascii_tex, ascii_uv + vec2( col * ( float( available_columns ) / float( max_columns ) ), 0.0 ) );
}

