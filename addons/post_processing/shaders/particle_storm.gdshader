// ParticleStormShader
// Copyright (c) 2025 Lou Bernardi (https://github.com/Loufe)
// A dynamic particle system shader designed to simulate natural phenomena like dust storms,
// snow flurries, or ash clouds with controllable wind direction and turbulence patterns.
// Features customizable particle density, color, and chaotic movement behaviors.

shader_type canvas_item;

// Visual appearance parameters
uniform vec4 particle_color : source_color = vec4(0.87, 0.78, 0.60, 1.0);
uniform vec2 wind_direction = vec2(1.0, 0.2);  // Normalized direction vector
uniform float wind_speed = 1.0;                // Movement speed multiplier
uniform float intensity = 0.5;                 // Overall particle visibility
uniform float chaos = 1.0;                     // Swirl movement intensity
uniform float scale = 1.0;                     // UV coordinate scaling factor
uniform float density = 1.0;                   // Particles per cell multiplier

// Generates a stable pseudo-random 2D vector from a 2D input
vec2 hash22(vec2 seed_position) {
    vec3 hash_input = fract(vec3(seed_position.xyx) * vec3(443.897, 441.423, 437.195));
    hash_input += dot(hash_input, hash_input.yzx + 19.19);
    return fract((hash_input.xx + hash_input.yz) * hash_input.zy);
}

// Calculates particle position based on time and initial conditions
vec2 get_particle_pos(vec2 cell_position, float particle_index, float current_time) {
    // Generate initial position using cell and particle index
    vec2 initial_position = hash22(cell_position + particle_index * 123.456);

    // Generate unique movement characteristics for this particle
    vec2 particle_characteristics = hash22(initial_position * 123.456);
    float velocity_variation = 0.7 + particle_characteristics.x * 0.6;

    // Calculate wind-driven movement
    vec2 wind_offset = wind_direction * current_time * velocity_variation;

    // Calculate swirling motion parameters
    float swirl_phase = current_time * (0.5 + particle_characteristics.y * 0.5);
    float swirl_amplitude = 0.1 + particle_characteristics.x * 0.1;
    vec2 swirl_offset = vec2(
        sin(swirl_phase + initial_position.y * 6.28),
        cos(swirl_phase + initial_position.x * 6.28)
    ) * swirl_amplitude * chaos;

    // Combine movements and wrap around unit space
    return fract(initial_position + wind_offset + swirl_offset);
}

// Renders a single square particle with soft edges
float get_pixel(vec2 current_uv, vec2 particle_center) {
    vec2 distance_to_center = abs(current_uv - particle_center);

    // Base particle size with scale adjustment
    float particle_size = 0.04 / scale;

    // Create soft-edged square shape
    float square_distance = max(distance_to_center.x, distance_to_center.y);
    return 1.0 - smoothstep(particle_size * 0.8, particle_size, square_distance);
}

void fragment() {
    // Transform UV coordinates to scaled space
    vec2 scaled_uv = UV * scale;
    vec2 current_cell = floor(scaled_uv);
    vec2 cell_local_uv = fract(scaled_uv);

    // Calculate time-based movement
    float current_time = TIME * wind_speed;

    float total_sand_density = 0.0;

    // Calculate particle count based on density parameter
    float particles_per_cell = floor(4.0 + density * 12.0);

    // Render particles from current and neighboring cells
    for (float x = -1.0; x <= 1.0; x++) {
        for (float y = -1.0; y <= 1.0; y++) {
            vec2 neighbor_offset = vec2(x, y);
            vec2 neighbor_cell = current_cell + neighbor_offset;

            // Generate and render all particles in this cell
            for (float particle_idx = 0.0; particle_idx < particles_per_cell; particle_idx++) {
                vec2 particle_pos = get_particle_pos(neighbor_cell, particle_idx, current_time);
                vec2 world_pos = (particle_pos + neighbor_offset);

                // Accumulate particle density
                total_sand_density += get_pixel(cell_local_uv, world_pos) * 0.25;
            }
        }
    }

    // Apply intensity and clamp to valid range
    total_sand_density *= intensity;
    total_sand_density = clamp(total_sand_density, 0.0, 1.0);

    // Quantize density for sharper particle appearance
    total_sand_density = floor(total_sand_density * 6.0) / 6.0;

    // Output final color with transparency
    COLOR = vec4(particle_color.rgb, total_sand_density * particle_color.a);
}