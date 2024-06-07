#version 300 es
precision highp float;

in vec2 vUv;
out vec4 oFragColor;

uniform float uTime;
uniform sampler2D uNoiseTex;

float noise(in vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float a = texture(uNoiseTex, (p + vec2(0.5, 0.5)) / 256.0).x;
    float b = texture(uNoiseTex, (p + vec2(1.5, 0.5)) / 256.0).x;
    float c = texture(uNoiseTex, (p + vec2(0.5, 1.5)) / 256.0).x;
    float d = texture(uNoiseTex, (p + vec2(1.5, 1.5)) / 256.0).x;
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

const mat2 mtx = mat2(0.80, 0.60, -0.60, 0.80);

float fbm(vec3 q) {
    vec2 p = q.xy;
    float f = 0.0;

    f += 0.500000 * noise(p + q.z);
    p = mtx * p * 2.02;
    f += 0.031250 * noise(p);
    p = mtx * p * 2.01;
    f += 0.250000 * noise(p);
    p = mtx * p * 2.03;
    f += 0.125000 * noise(p);
    p = mtx * p * 2.01;
    f += 0.062500 * noise(p);

    return f / 0.96875;
}

void main() {
    float time = uTime * 0.4;
    float edgeTime = uTime * 0.5;

    // noise
    vec2 nUv = vUv.xy * 18.;
    vec2 nxy = vec2(fbm(vec3(12345. + nUv, -time)));
    float n = fbm(vec3(vUv * 50., -edgeTime));

    nxy = nxy * 2. - 1.;
    nxy = smoothstep(0., 1., nxy);

    oFragColor = vec4(nxy, n, 1.);

}
