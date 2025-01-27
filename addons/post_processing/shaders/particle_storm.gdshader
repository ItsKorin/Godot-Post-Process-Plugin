// ParticleStormShader
// Copyright (c) 2025 Lou Bernardi (https://github.com/Loufe)
// A dynamic particle system shader designed to simulate natural phenomena like dust storms,
// snow flurries, or ash clouds with controllable wind direction and turbulence patterns.
// Features customizable particle density, color, and chaotic movement behaviors.

/*
Parameters:
- particle_color: Base color of the particles (includes alpha)
- wind_direction: 2D vector for flow direction
- wind_speed: Overall movement speed
- intensity: Global particle visibility
- chaos: Amount of turbulent motion
- scale: Size of the particle system
- density: Base particle count multiplier
*/

shader_type canvas_item;

// Uniform parameters that can be modified from outside the shader
uniform vec4 particle_color : source_color = vec4(0.87, 0.78, 0.60, 1.0);  // Defaults to a sandy color
uniform vec2 wind_direction = vec2(1.0, 0.2);                              // Default wind blows right and slightly up
uniform float wind_speed = 1.0;                                            // Base movement speed
uniform float intensity = 0.5;                                             // Overall particle visibility
uniform float chaos = 1.0;                                                 // Amount of swirl/turbulence
uniform float scale = 1.0;                                                 // Overall size of the effect
uniform float density = 1.0;                                               // Number of particles to render

// Core constants for the particle system
const float TWO_PI = 6.28318530718;                                       // Optimization: pre-calculated 2*PI
const float INVERSE_QUANTIZE = 0.166666667;                               // Optimization: pre-calculated 1.0/6.0
const vec3 HASH_SCALE = vec3(443.897, 441.423, 437.195);                 // Prime numbers for pseudo-random generation
const float MIN_PARTICLE_RATIO = 0.25;                                    // Minimum particles at edge of effect
const float BASE_PARTICLE_SIZE = 0.04;                                    // Base size of each particle
const float PARTICLE_INDEX_OFFSET = 123.456;                              // Offset for particle position variation
const float HASH_OFFSET = 123.456;                                        // Offset for hash calculation
const float SWIRL_SCALE = 0.1;                                           // Base scale of swirling motion

// Varying variables passed from vertex to fragment shader
varying float particle_size;       // Calculated size of particles based on scale
varying float base_particles;      // Number of particles to generate
varying float velocity_base;       // Base velocity calculation
varying float velocity_range;      // Range of velocity variation
varying float swirl_factor;        // Optimization: pre-calculated swirl scale * chaos

// Vertex shader: pre-calculate values that are constant for all fragments
void vertex() {
    particle_size = BASE_PARTICLE_SIZE / scale;
    base_particles = floor(4.0 + density * 12.0);
    velocity_base = wind_speed * 0.7;                // Base speed component
    velocity_range = wind_speed * 0.6;              // Variable speed component
    swirl_factor = SWIRL_SCALE * chaos;             // Pre-calculate swirl intensity
}

// Generate a pseudo-random 2D vector from a 2D position
// Uses a combination of dot products and hash functions for stable randomization
vec2 hash22(vec2 seed_position) {
    vec3 hash_input = fract(vec3(seed_position.xyx) * HASH_SCALE);
    hash_input += dot(hash_input, hash_input.yzx + 19.19);
    return fract((hash_input.xx + hash_input.yz) * hash_input.zy);
}

// Calculate how many particles to render for a given grid cell
// Reduces particle count for cells further from center
float get_cell_particle_count(vec2 offset) {
    float dist_squared = dot(offset, offset);
    float falloff = 1.0 - smoothstep(1.0, 2.0, dist_squared);
    return base_particles * max(MIN_PARTICLE_RATIO, falloff);
}

// Calculate the position of a specific particle
vec2 get_particle_pos(vec2 cell_position, float particle_index, float time_factor) {
    // Generate unique seed for this particle
    vec2 seed_offset = cell_position + particle_index * PARTICLE_INDEX_OFFSET;
    vec2 initial_position = hash22(seed_offset);
    vec2 particle_characteristics = hash22(initial_position * HASH_OFFSET);
    
    // Calculate particle-specific properties
    float velocity = velocity_base + particle_characteristics.x * velocity_range;
    float time_phase = time_factor * (0.5 + particle_characteristics.y * 0.5);
    float pos_phase_x = initial_position.x * TWO_PI;
    float pos_phase_y = initial_position.y * TWO_PI;
    
    // Combine wind and swirl movements
    vec2 wind_offset = wind_direction * time_factor * velocity;
    vec2 swirl_offset = vec2(
        sin(time_phase + pos_phase_y),
        cos(time_phase + pos_phase_x)
    ) * swirl_factor;
    
    return fract(initial_position + wind_offset + swirl_offset);
}

// Calculate the intensity of a pixel based on distance from particle center
float get_pixel(vec2 distance_to_center) {
    float square_distance = max(distance_to_center.x, distance_to_center.y);
    float size_factor = particle_size * 0.8;
    return 1.0 - smoothstep(size_factor, particle_size, square_distance);
}

// Fragment shader: calculate the color of each pixel
void fragment() {
    // Calculate basic UV coordinates and time
    vec2 scaled_uv = UV * scale;
    vec2 current_cell = floor(scaled_uv);
    vec2 cell_local_uv = fract(scaled_uv);
    float current_time = TIME * wind_speed;

    float total_sand_density = 0.0;
    
    // Process a 3x3 grid of cells around current position
    for (float x = -1.0; x <= 1.0; x++) {
        for (float y = -1.0; y <= 1.0; y++) {
            vec2 offset = vec2(x, y);
            vec2 neighbor_cell = current_cell + offset;
            
            // Get number of particles for this cell
            float local_particle_count = get_cell_particle_count(offset);
            
            // Process each particle in the cell
            for (float particle_idx = 0.0; particle_idx < local_particle_count; particle_idx++) {
                vec2 particle_pos = get_particle_pos(neighbor_cell, particle_idx, current_time);
                vec2 distance_to_center = abs(cell_local_uv - (particle_pos + offset));
                total_sand_density += get_pixel(distance_to_center) * 0.25;
            }
        }
    }
    
    // Apply intensity and quantization for final output
    total_sand_density = clamp(total_sand_density * intensity, 0.0, 1.0);
    total_sand_density = (floor(total_sand_density * 6.0 + 0.5)) * INVERSE_QUANTIZE;
    
    // Set final color with calculated alpha
    COLOR = vec4(particle_color.rgb, total_sand_density * particle_color.a);
}