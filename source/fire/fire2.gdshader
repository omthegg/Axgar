shader_type canvas_item;

uniform float time;
uniform vec2 resolution;

float rand(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * rand(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 flameUV = uv * vec2(resolution.x / resolution.y, 1.0);
    flameUV.y -= 0.5;

    // Animate upward flow
    flameUV.y += time * 0.5;

    // Turbulent shape
    float turbulence = fbm(flameUV * 3.0);
    float shape = exp(-length(flameUV - vec2(0.5, 0.0)) * 3.0) + turbulence * 0.6;

    // Color gradient
    vec3 color = vec3(0.0);
    color = mix(color, vec3(0.8, 0.2, 0.0), smoothstep(0.2, 0.4, shape)); // deep orange
    color = mix(color, vec3(1.0, 0.6, 0.0), smoothstep(0.4, 0.6, shape)); // bright orange
    color = mix(color, vec3(1.0, 1.0, 0.5), smoothstep(0.6, 0.8, shape)); // yellow-white

    // Optional shimmer
    float shimmer = sin(flameUV.y * 10.0 + time * 5.0) * 0.05;
    color += shimmer;

    COLOR = vec4(color, shape);
}