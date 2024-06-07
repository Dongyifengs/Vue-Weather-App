#version 300 es
precision highp float;
in vec2 vUv;

uniform vec2 uResolution;
uniform float uOpacity;
uniform float uAlpha;
uniform float uTime;
uniform float uHeaviness;
uniform float uFilter;
uniform sampler2D uNoiseTex;
uniform float uQuality;
out vec4 oFragColor;

#define WIDTH 0.3
#define SIZE 1.0
#define SPEED_Y 1.4
#define NOISE_SIZE 256.
#define CELL_NOISE_COORD 0.005859375
#define CLOSEST_INDEX 2.1
#define FURTHEST_INDEX 4.1

float fixRamp(float a, float b, float c, float y) {
    float r = mix(a, b, smoothstep(0.0, 1.0, clamp(y, 0.0, 0.5) * 2.0));
    r = mix(r, c, smoothstep(0.0, 1.0, (clamp(y, 0.5, 1.0) - 0.5) * 2.0));
    return r;
}

float N11(float n) {
    return fract(sin(n * 871.213) * 3134.422);
}

float N21(vec2 uv) {
    return N11(N11(uv.x) + uv.y);
}

vec4 weatherEffect(vec2 uv) {

    float time = uTime + 100.;

    float layerDensity = fixRamp(1.3, 1.9, 2.6, uHeaviness);
    float depth = fixRamp(4.8, 4.2, 3.8, uHeaviness);
    float preDepth = depth * 0.03;

    vec2 st = uv * 0.5;
    st.x *= uResolution.x / uResolution.y;

    vec2 scaledUV = st * depth * layerDensity;
    float preYMove = SPEED_Y * time * layerDensity;


    vec3 outcome = vec3(0.0);
    float dof = 5. * sin(time * .1);
    dof = 5.;

    float q = uQuality * 2.0;
    for (float layerIndex = CLOSEST_INDEX; layerIndex < FURTHEST_INDEX + q; layerIndex++) {

        if(uFilter >= 0.) {
            if(layerIndex > abs(uFilter)) continue;
        } else {
            if(layerIndex <= abs(uFilter)) continue;
        }

        vec2 depUV = layerIndex * scaledUV;

        depUV += vec2(depUV.y * WIDTH * (fract(layerIndex * 7.238917) - 0.5),    preYMove / (1. + layerIndex * preDepth));

        vec2 cellIndex = floor(depUV);

        vec3 randNum2 = texture(uNoiseTex, vec2((cellIndex + layerIndex) * CELL_NOISE_COORD)).xyz;
        vec2 posOffset = vec2((sin(N21(cellIndex) * 128. + time) * .4), (sin(N11(N21(cellIndex)) * 128. + time) * .4));
        vec2 posUV = abs(fract(depUV + posOffset) - 0.5);
        posUV += 0.01 * abs(2. * fract(10. * depUV.yx) - 1.);

        float d = .6 * max(posUV.x - posUV.y, posUV.x + posUV.y) + max(posUV.x, posUV.y) - .01;
        float edge = .005 + .05 * min(.5 * abs(layerIndex - 5. - dof), 1.);
        float snowflake = smoothstep(edge * SIZE * layerDensity, -edge * SIZE * layerDensity, d) * (randNum2.x / (1. + 0.02 * layerIndex * depth));

        outcome += vec3(snowflake);
    }
    return vec4(1., 1., 1., outcome.r * uAlpha);
}

void main() {
    vec2 uv = vUv;

    vec4 effect = weatherEffect(uv);
    effect.a *= uOpacity;

    oFragColor = effect;
}
