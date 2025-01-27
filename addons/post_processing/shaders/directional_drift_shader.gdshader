// DirectionalDriftShader
// Copyright (c) 2025 Lou Bernardi (https://github.com/Loufe)
// A versatile shader for creating directional particle effects like sandstorms, snow, or mist
// using layered noise patterns for natural movement.

shader_type canvas_item;

uniform vec4 particle_color: source_color = vec4(0.76, 0.69, 0.5, 0.3);  // Base color with alpha
uniform float particle_density: hint_range(0.0, 3.0) = 0.3;              // Controls the amount of visible particles
uniform float flow_speed: hint_range(0.0, 5.0) = 1.0;                    // Base movement speed
uniform float pattern_scale = 30.0;                                      // Controls size and distribution of particles
uniform vec2 normalized_flow_direction = vec2(0.89442719, 0.4472136);   // Normalized direction vector (default 1.0, 0.5 normalized)
uniform float layer_velocity_ratio = 1.2;                               // Speed multiplier for second noise layer
const float SPEED_SCALE = 0.3;                                          // Internal speed scaling factor (30%)

// Optimized noise generation using combined cellular and gradient noise
// Provides good distribution while maintaining efficiency
vec2 generate_noise_vector(vec2 position) {
    vec2 i = floor(position);
    vec2 f = fract(position);
    
    // Generate vectors using simple but effective hash
    vec2 hash = fract(sin(vec2(
        dot(i, vec2(12.9898, 78.233)),
        dot(i, vec2(43.5453, 28.179))
    )) * 43758.5453);
    
    // Mix in cellular noise characteristics for better particle distribution
    return hash + 0.5 * sin(6.2831 * f);
}

// Smooth noise function for organic particle movement
float create_smooth_noise(vec2 position) {
    vec2 integer_pos = floor(position);
    vec2 fractional_pos = fract(position);

    // Smooth interpolation curve
    fractional_pos = fractional_pos * fractional_pos * (3.0 - 2.0 * fractional_pos);

    // Sample points for bilinear interpolation
    float point_a = length(generate_noise_vector(integer_pos));
    float point_b = length(generate_noise_vector(integer_pos + vec2(1.0, 0.0)));
    float point_c = length(generate_noise_vector(integer_pos + vec2(0.0, 1.0)));
    float point_d = length(generate_noise_vector(integer_pos + vec2(1.0, 1.0)));

    // Bilinear interpolation for smooth noise
    return mix(
        mix(point_a, point_b, fractional_pos.x),
        mix(point_c, point_d, fractional_pos.x),
        fractional_pos.y
    );
}

void fragment() {
    // Use pre-normalized direction vector to avoid per-fragment normalization
    // Negate the direction to match expected coordinate system
    vec2 time_offset = normalized_flow_direction * TIME * flow_speed * SPEED_SCALE;
    vec2 primary_offset = UV - time_offset;
    vec2 secondary_offset = UV - (time_offset * layer_velocity_ratio);

    // Generate two noise layers with different scales
    float primary_noise = create_smooth_noise(primary_offset * pattern_scale);
    float secondary_noise = create_smooth_noise(secondary_offset * (pattern_scale * 0.8));

    // Blend layers with weighted contribution
    float composite_noise = (primary_noise * 0.6 + secondary_noise * 0.4);

    // Create stepped appearance for distinct particles
    float quantized_noise = floor(composite_noise * 4.0) / 4.0;

    // Apply final color and transparency
    COLOR = vec4(particle_color.rgb, quantized_noise * particle_density * particle_color.a);
}