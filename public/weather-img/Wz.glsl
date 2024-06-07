#version 300 es
precision highp float;
in vec2 vUv;
flat in float vtargetAlpha[5];
flat in float vtargetScale[5];
flat in float uIntensity1;
flat in float uIntensity2;
flat in float uIntensity3;
flat in float uIntensity4;
flat in int uFilter1;

uniform float uOpacity;
uniform float uAlpha;
uniform float uTime;
uniform float uSpeedY;
uniform vec2 uResolution;
uniform sampler2D uNoiseTex;
uniform int uQuality;
out vec4 oFragColor;

float PI = 3.14;
#define NOISE_SIZE 256.
#define CELL_NOISE_COORD 0.005859375
#define SCALE_X 20.
#define SCALE_Y 0.028
#define SCALE 5.

vec3 getRandomLite (float value, int seed) {
    vec3 rg = texture(uNoiseTex, vec2((value + float(seed)) * CELL_NOISE_COORD)).rgb;
    return rg;
}

vec4 drawDropLayer(vec2 uv, float scale, float alpha, int index) {
    uv *= scale;
    float time = uTime;
    vec2 coord = uv * uResolution.xy;
    uv = (coord.xy - 0.5 * uResolution.xy) / uResolution.y;
    vec3 color = vec3(1.0);
    uv.x = uv.x * SCALE_X;
    float dx = fract(uv.x);
    uv.x = floor(uv.x);
    float dropTime = (time + 100.) * uSpeedY;
    uv.y *= uIntensity2;
    vec3 rg = getRandomLite(uv.x, index);
    float offset = (rg.x + rg.y - 1.5) * 3.;
    float speed = offset * 0.033 + 0.7;

    float trail = 95.;
    float yv = fract(uv.y + dropTime * speed - 0.1 * uSpeedY * uIntensity3 + offset) * trail;
    yv = 1.0 / yv;
    yv = smoothstep(0.0, 1.0, yv * yv);
    float alphaGradient = clamp(yv + 0.5, 0., 1.);
    yv = sin(yv * PI) * (speed * 5.0);
    float d2 = sin(dx * PI);
    yv *= d2 * d2;
    if (index == 0 && rg.b > 0.4 && uIntensity1 > 4.5) {
        return vec4(color, smoothstep(0., 1., yv) * alphaGradient * alpha);
    } else if (index != 0 && offset > uIntensity4) {
        return vec4(color, smoothstep(0., 1., yv) * alphaGradient * alpha);
    }
    return vec4(0.);
}

vec4 weatherEffect(vec2 uv) {
    vec4 color = vec4(0.);

    float targetAlpha1 = 0.8;
    float targetScale1 = 1.;
    if (uFilter1 >= 0) {
        color += drawDropLayer(uv, 10. + targetScale1 * SCALE, uAlpha * targetAlpha1, 0);
        color = clamp(color, 0., 1.);
        color.a *= mix(1., 0.7, smoothstep(0.1, 1., uv.y));
    }
    int q = uQuality * 3;
    for (int i = 0; i < 2 + q; i++) {
        if (vtargetScale[i] == 0.0) {
            continue;
        }
        color += drawDropLayer(uv, 10. + vtargetScale[i] * SCALE, uAlpha * vtargetAlpha[i], i + 1);
        color = clamp(color, 0., 1.);
        color.a *= mix(1., 0.5, smoothstep(0.1, 1., uv.y));
    }
    return color;
}

void main() {
    vec2 uv = vUv;
    vec4 col = weatherEffect(uv);
    col.a *= uOpacity;
    oFragColor = col;
}
