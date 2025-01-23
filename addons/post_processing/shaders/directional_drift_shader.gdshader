// DirectionalDriftShader
// Copyright (c) 2025 Lou Bernardi (https://github.com/Loufe)
// A versatile shader for creating directional particle effects like sandstorms, snow, or mist
// using layered noise patterns for natural movement.

shader_type canvas_item;

uniform vec4 particle_color: source_color = vec4(0.76, 0.69, 0.5, 0.3);  // Base color with alpha
uniform float particle_density: hint_range(0.0, 3.0) = 0.3;              // Controls the amount of visible particles
uniform float flow_speed: hint_range(0.0, 5.0) = 1.0;                    // Base movement speed
uniform float pattern_scale = 30.0;                                      // Controls size and distribution of particles
uniform vec2 flow_direction = vec2(1.0, 0.5);                           // Direction of particle movement
uniform float layer_velocity_ratio = 1.2;                               // Speed multiplier for second noise layer
const float SPEED_SCALE = 0.3;                                          // Internal speed scaling factor (30%)

// Enhanced noise generation for natural-looking distribution
vec2 generate_noise_vector(vec2 position) {
    return fract(sin(vec2(
        dot(position, vec2(127.1, 311.7)),
        dot(position, vec2(269.5, 183.3))
    )) * 43758.5453123);
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
    // Ensure consistent movement speed regardless of direction magnitude
    vec2 normalized_direction = normalize(flow_direction);

    // Create two offset layers moving at different speeds for parallax effect
    // Negate the normalized direction to match expected coordinate system
    vec2 primary_offset = UV - (normalized_direction * TIME * flow_speed * SPEED_SCALE);
    vec2 secondary_offset = UV - (normalized_direction * TIME * flow_speed * layer_velocity_ratio * SPEED_SCALE);

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