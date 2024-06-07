#version 300 es
precision lowp float;
in vec2 vUv;
out vec4 oFragColor;

uniform vec2 uResolution;
uniform float uOpacity;

uniform float uAlpha;
uniform float uLineAlpha;
uniform float uAnnulusAlpha;
uniform float uCircleAlpha;
uniform float uCircleOffset;
uniform float uCircleOffsetRatio;

uniform sampler2D uNoiseTex;
uniform sampler2D uAnnulusTex;
uniform sampler2D uObviousLineTex;
uniform sampler2D uSunTex;
uniform float uQuality;

in vec4 light;
in float circleNumber;
in float randSeed;
in vec2 sunPos;

#define SUN_DEGREE 2.
#define LINE_SPEED 0.5
#define LINE_COLOR vec4(1.0, 0.8078, 0.3922, 1.0)

#define CIRCLE_SIZE 0.95

#define DECAY 5.
#define PI 3.1415926
#define NOISE_SIZE 256.
#define CELL_NOISE_COORD 0.005859375

vec3 getRandomLite(float value, float seed) {
    vec3 rg = texture(uNoiseTex, vec2((value + seed) * CELL_NOISE_COORD)).rgb;
    return rg;
}

float getRandom(float value, float seed) {
    return fract(sin(value * 999.9) * seed);
}

const vec3 colorLUT[] = vec3[](vec3(0.1686, 0.7412, 0.2353),
                               vec3(1.0, 0.3843, 0.0),
                               vec3(1.0, 0.5333, 0.0),
                               vec3(0.7804, 1.0, 0.3725),
                               vec3(1.0, 0.5333, 0.0),
                               vec3(1.0, 0.3843, 0.0),
                               vec3(1.0, 0.5333, 0.0),
                               vec3(1.0, 0.5333, 0.0),
                               vec3(1.0, 0.2588, 0.1294));

vec3 getColor(int index) {
    return colorLUT[index];
}

vec3 getCircle(int index, vec2 uv, float size, float dist, vec2 sunPos, float blur) {

    blur = mix(0.45, 1., blur);
    vec3 color = getColor(index);
    vec3 f = vec3(0.);

    float c = max(0.01 - pow(length(uv + sunPos * dist), size * 1.4), 0.) * 50.;
    float c1 = (c > 0.1) ? (0.1 - (c - 0.1) / 5.) : (c / 1.4) * blur * 2.;
    float c2 = mix(c1, c, (blur > 0.5) ? ((blur - 0.5) * 2.) : 0.);

    float alpha = uCircleAlpha * mix(1., 0.4, (size - 1.) * 3.) * ((blur >= 0.82) ? 0.5 : 1.);
    f += c2 * color * alpha;

    return f - 0.01;
}

vec4 getWeatherEffect(vec2 uv) {

    vec3 color = vec3(0.);
    float lsun = length(sunPos);

    if (uQuality > 0.) {
        float d = abs(sunPos.x * uv.y - sunPos.y * uv.x) / lsun;
        if (d > 0.1) {
            color -= 0.01 * circleNumber;
        } else {
            float l = dot(normalize(sunPos), uv);
            float threshL = length(clamp(sunPos * uCircleOffset, -1.0, 0.0));
            if (l > threshL + 0.1 || l < -0.8 * lsun + threshL - 0.1) {
                color -= 0.01 * circleNumber;
            } else {
                for (float i = 0.; i < circleNumber; i++) {
                    vec3 rg = getRandomLite(i, randSeed);
                    float staticSize = rg.r * 0.33 + CIRCLE_SIZE;
                    float size = staticSize + light.a;
                    float staticDist = uCircleOffset + rg.g * mix(0.5, 0.2, uCircleOffsetRatio) + (i / 30. + pow(i, 2.) * 0.01);
                    float dist = staticDist + light.a;
                    color += getCircle(int(i), uv, size, dist, sunPos, rg.b);
                }
            }
        }
    }

    vec2 diff = uv - sunPos;
    vec2 st = clamp(1.6 * diff + 0.4 * uv + 0.5, 0.0, 1.0);
    color += texture(uAnnulusTex, st).rgb * uAnnulusAlpha;

    vec2 st2 = clamp((diff) / 3.0 + 0.5, 0.0, 1.0);
    color += texture(uObviousLineTex, st2).rgb;

    float angle = atan(diff.y, diff.x);
    vec3 angleArr = vec3(angle, angle + PI / 5., angle + PI / 2.);
    vec3 dimLine = abs(sin(angleArr * 3. + cos(angleArr * 9.))) * (abs(sin(angleArr * 9.))) * light.rgb;
    color += vec3(dimLine.x + dimLine.y + dimLine.z) * 1.2;

    vec2 st3 = clamp(diff + 0.5, 0.0, 1.0);
    color += texture(uSunTex, st3).rgb * 2.0;

    color *= exp(1.0 - length(diff)) / DECAY;
    color = clamp(color, 0.0, 1.0) * smoothstep(-0.5, 0.1, uv.y);

    return vec4(color, 1.);
}

void main() {
    vec2 uv = vUv;
    vec4 effect = getWeatherEffect(uv);
    effect.a *= uOpacity;
    oFragColor = effect;
}