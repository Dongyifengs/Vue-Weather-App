#version 300 es
precision highp float;

in vec2 vUv;
out vec4 oFragColor;

uniform float uOpacity;
uniform float uAlpha;
uniform vec3 uColor;
uniform sampler2D uNoiseTex;
in vec2 st;
in vec2 slow;
in vec2 fast;

float rand(vec2 co) {
    return fract(cos(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float fractalNoiseFast(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float a = textureLod(uNoiseTex, (p + vec2(0.5, 0.5)) / 256.0, 0.0).x;
    float b = textureLod(uNoiseTex, (p + vec2(1.5, 0.5)) / 256.0, 0.0).x;
    float c = textureLod(uNoiseTex, (p + vec2(0.5, 1.5)) / 256.0, 0.0).x;
    float d = textureLod(uNoiseTex, (p + vec2(1.5, 1.5)) / 256.0, 0.0).x;
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float valueNoiseSimple(vec2 vl) {
    float minStep = 1.0;

    vec2 grid = floor(vl);
    vec2 gridPnt1 = grid;
    vec2 gridPnt2 = vec2(grid.x, grid.y + minStep);
    vec2 gridPnt3 = vec2(grid.x + minStep, grid.y);
    vec2 gridPnt4 = vec2(gridPnt3.x, gridPnt2.y);

    float s = rand(grid);
    float t = rand(gridPnt3);
    float u = rand(gridPnt2);
    float v = rand(gridPnt4);

    float x1 = smoothstep(0., 1., fract(vl.x));
    float interpX1 = mix(s, t, x1);
    float interpX2 = mix(u, v, x1);

    float y = smoothstep(0., 1., fract(vl.y));
    float interpY = mix(interpX1, interpX2, y);

    return interpY;
}

float fractalNoise(vec2 vl) {
    float rez = 0.5 * valueNoiseSimple(vl);
    rez += 0.25 * valueNoiseSimple(vl * 2.);
    rez += 0.125 * valueNoiseSimple(vl * 4.);
    rez += 0.0625 * valueNoiseSimple(vl * 8.);
    return rez;
}

float complexFBM(vec2 p, vec2 offset1, vec2 offset2) {
    return fractalNoise(offset1 + fractalNoise(p + fractalNoiseFast(p + 2. * fractalNoiseFast(offset2))));
}

vec4 weatherEffect(vec2 uv) {
    float n = complexFBM(st, slow, fast);
    if (n < 0.0001)return vec4(0.0);
    float alpha = min(mix(1., 0.8, smoothstep(0.8, 1., uv.y)), mix(0.2, 1., smoothstep(0., 0.3, uv.y)));
    return vec4(uColor, n * alpha * uAlpha);
}

void main() {
    vec2 uv = vUv;

    vec4 effect = weatherEffect(uv);
    effect.a *= uOpacity;

    oFragColor = effect;
}