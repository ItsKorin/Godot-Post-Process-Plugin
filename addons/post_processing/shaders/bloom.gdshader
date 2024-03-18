shader_type canvas_item;
render_mode blend_add;

#include "CLREDIT.gdshaderinc"

uniform lowp sampler2D Screen_Sample : hint_screen_texture, filter_linear_mipmap_anisotropic;
uniform lowp sampler2D FlareTex; // Texture for the lens flare

uniform float BlurAmount; // Adjust blur intensity
uniform float FlareThreshold; // Threshold for brightness to consider flare
uniform int Flares; // Number of lens flares
uniform float FlareSpacing; // Separation between flares
uniform float Intensity; // Overall intensity of the effect
uniform float Saturation_; // Adjust color saturation (optional)
uniform float FalloffStart; // Controls falloff start distance from center (0-1)
uniform float FalloffEnd; // Controls falloff end distance from center (0-1)

void fragment() {
  //UV = SCREEN_UV;

  // Sample the scene color
  vec3 SceneColor = texture(Screen_Sample, UV).rgb;

  // Calculate direction vector from screen center (static)
  vec2 FlareDir = vec2(0.5) - UV;

  // Accumulate flare color with falloff
  vec3 FinalFlare = vec3(0.0);
  for (int i = 0; i < Flares; ++i) {
    // Offset UV based on flare direction and index
    vec2 SampleUV = fract(UV + FlareDir * (BlurAmount + vec2(float(i) * FlareSpacing)));

    // Sample the scene with blur in flare direction
    vec3 BlurredScene = texture(Screen_Sample, SampleUV, BlurAmount).rgb;

    // Apply threshold to filter out dark areas
    BlurredScene = ApplyThreshold(BlurredScene, FlareThreshold); // Adjust threshold as needed (optional)

    // Calculate distance from center for falloff
    float Dist = distance(SampleUV, vec2(0.5));
    float Falloff = smoothstep(FalloffStart, FalloffEnd, Dist);

    // Apply weight and accumulate flare color
    FinalFlare += BlurredScene * Falloff;
  }

  // Apply lens flare texture
  FinalFlare *= texture(FlareTex, UV).rgb;

  // Apply intensity and optional saturation adjustment
  COLOR.rgb = FinalFlare * Intensity;
  COLOR.rgb = Saturation(COLOR.rgb, Saturation_); // Adjust saturation as needed (optional)
}
