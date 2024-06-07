#version 300 es
precision highp float;

in vec2 vUv;
out vec4 oFragColor;

uniform vec2 uResolution;
uniform float uOpacity;

uniform sampler2D uNoiseTex;
uniform sampler2D uPerlinNoiseTex;
uniform float uAlpha;
uniform float uTime;
uniform float uSpeedX;
uniform vec4 uColor1;
uniform vec4 uColor2;
uniform vec4 uColor3;
uniform vec4 uColor4;
uniform vec4 uColor5;

#define NOISE_TYPE 0

#if NOISE_TYPE == 0
vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float pnoise(vec2 p) {
    float K1 = 0.366025404;
    float K2 = 0.211324865;

    vec2 i = floor(p + (p.x + p.y) * K1);
    vec2 a = p - i + (i.x + i.y) * K2;
    float m = step(a.y, a.x);
    vec2 o = vec2(m, 1.0 - m);
    vec2 b = a - o + K2;
    vec2 c = a - 1.0 + 2.0 * K2;
    vec3 h = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    vec3 n =
    h * h * h * h *
    vec3(dot(a, hash(i + 0.0)), dot(b, hash(i + o)), dot(c, hash(i + 1.0)));
    return dot(n, vec3(70.0));
}

vec2 rand(vec2 co) {
    return fract(sin(vec2(dot(co, vec2(127.1, 311.7)), dot(co, vec2(269.5, 183.3)))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(dot(rand(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(rand(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(rand(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(rand(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

float noise(float x, float y) { return noise(vec2(x, y)); }

#else

float pnoise(vec2 p) { return texture(uPerlinNoiseTex, p).r; }
float noise(vec2 p) { return texture(uNoiseTex, p).r; }

#endif

float fixRamp(float a, float b, float c, float y) {
    float r = mix(a, b, smoothstep(0.0, 1.0, clamp(y, 0.0, 0.5) * 2.0));
    r = mix(r, c, smoothstep(0.0, 1.0, (clamp(y, 0.5, 1.0) - 0.5) * 2.0));
    return r;
}

float within(float e1, float e2, float x) {
    return step(e1, x) * (1.0 - step(e2, x));
}

vec4 weatherEffect(vec2 uv) {
    float time = uTime;
    float speedX = uSpeedX;

    float N = 5.0;

    float rNm1 = 1.0 / (N - 1.0);
    float rN = 1.0 / N;

    vec4 color = vec4(0.0);

    for (float i = 0.0; i < N; i++) {
        vec2 st = uv;
        st.y *= uResolution.y / uResolution.x;

        #if NOISE_TYPE == 0
        vec2 speedAlternationHz = vec2(0.6, 0.2);
        float n1 = noise(vec2(time * speedAlternationHz.x, i * 10.0));
        float n2 = noise(vec2(time * speedAlternationHz.y, i * 20.0));
        #else
        vec2 speedAlternationHz = vec2(0.01, 0.001);
        float n1 = noise(vec2(time * speedAlternationHz.x, i * 0.01));
        float n2 = noise(vec2(time * speedAlternationHz.y, i * 0.02));
        #endif


        float a = 0.0;

        #if NOISE_TYPE == 0
        st *= 25.0 + i * 10.0;
        st.x -= mix(time, time + 0.5, n1) * speedX * mix(1.0, 0.5, i * rNm1);
        st.y -= mix(-10.0 + i * 50.0, 10.0 + i * 50.0, n2);
        a = smoothstep(0.75 + i * 0.01, 0.9 + i * 0.01, pnoise(st));
        #else
        st *= 1.0 + i * 0.3;
        st.x += i * 0.3;

        st.x -= mix(time, time + 0.5, n1) * uSpeedX / 25.0 * mix(0.9, 0.4, i * rNm1);
        st.y -= mix(-4.0 + i * rN, 4.0 + i * rN, n2);

        a = smoothstep(0.97 + i * 0.001, 0.99 + i * 0.002, pnoise(vec2((st.x - i * rN) / 8.0, st.y / 2.0)));
        #endif

        color.rgb +=
        within(-0.1, 0.1, i) * uColor1.rgb * a +
        within(0.9, 1.1, i) * uColor2.rgb * a +
        within(1.9, 2.1, i) * uColor3.rgb * a +
        within(2.9, 3.1, i) * uColor4.rgb * a +
        within(3.9, 4.1, i) * uColor5.rgb * a;

        color.a += a * (N - i) * rN * 0.3;
    }

    color.a *= uAlpha;

    return color;
}

void main() {
    vec2 uv = vUv;

    vec4 effect = weatherEffect(uv);
    effect.a *= uOpacity;

    oFragColor = effect;
}