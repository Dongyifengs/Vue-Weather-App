#version 300 es
precision highp float;

in vec2 vUv;
in float starID;
in float curtTime;
in float uLife1;
out vec4 oFragColor;

uniform vec2 uResolution;
uniform float uSpeed;
uniform float uOpacity;

float PI = 3.1415926;
float PI2 = 6.2831852;

float randomFloat(in float value, in float seed) {
    return fract(sin(value * 999.9) * seed);
}

vec2 randVector(in vec2 vec, in float seed) {
    return vec2(fract(sin(vec.x * 999.9 + vec.y) * seed), fract(sin(vec.y * 999.9 + vec.x) * seed));
}

vec3 drawMeteor(vec2 newUV, float curtTime, float life, float angle, vec2 position) {
    if (curtTime >= life) return vec3(0.);
    vec3 starColor = vec3(1.0f);
    float ShowTime = 0.3 * life;
    float HideTime = 0.5 * life;

    newUV += position;
    newUV *= 10.;
    float angleInRadians = angle * PI / 180.;
    vec2 rotation = vec2(sin(angleInRadians), cos(angleInRadians));
    newUV = vec2(newUV.x * rotation.y + newUV.y * rotation.x, newUV.y * rotation.y - newUV.x * rotation.x);

    newUV.x = newUV.x * 50.;
    newUV.y *= 0.15;
    float dx = fract(newUV.x);
    newUV.x = floor(newUV.x);
    if (newUV.x != 0.) return vec3(0.);

    float time = curtTime * 0.4;
    float speed = uSpeed;

    float trail = 35.;
    float yv = fract(newUV.y + time * speed) * trail;
    yv = 1.0 / yv;
    if (floor((newUV.y + time * speed) / 1.) != 0.) yv = 0.;
    float originalLine = yv;

    float trailControl = 0.;
    float alphaControl = 1.;
    if (curtTime <= ShowTime) {
        trailControl = mix(1., 0., pow((curtTime / ShowTime), 0.06));
        alphaControl = mix(0., 1., curtTime / ShowTime * 1.7);
    } else if ((life - curtTime) <= HideTime) {
        trailControl = mix(1., 0., pow(((life - curtTime) / HideTime), 0.1));
        alphaControl = mix(0., 1., (life - curtTime) / HideTime);
    }
    yv = clamp(yv * yv, 0., 1.);
    yv = smoothstep(trailControl, 1., yv);

    yv = sin(yv * PI) * (speed * 5.0);
    float d2 = sin(dx * PI);
    yv *= d2 * d2;

    starColor = starColor * yv * alphaControl;
    return starColor;
}

vec4 weatherEffect(vec2 uv) {

    vec4 color = vec4(0.0);
    vec2 coord = uv * uResolution.xy;

    vec2 newUV = (coord.xy - 0.5 * uResolution.xy) / uResolution.y;

    float randomAngleTmp = mix(280., 295., randomFloat(starID, 8349.71));
    vec2 randomPosition = vec2(mix(-0.3, -0.4, randomFloat(starID, 636.93)), mix(-0.3, -0.6, randomFloat(starID, 748.91)));
    vec3 starColor = drawMeteor(newUV, curtTime, uLife1, randomAngleTmp, randomPosition);

    color = vec4(starColor, 1.0);

    color *= uv.y;

    return color;
}

void main() {
    vec2 uv = vUv;

    vec4 effect = weatherEffect(uv);
    effect.a *= uOpacity;

    oFragColor = effect;
}