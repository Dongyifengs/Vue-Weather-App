#version 300 es
precision highp float;
in vec2 vUv;
in vec2 starcoorduv;
in float utime;
in vec2 cloudCoord1uv;
in float sintime;
out vec4 oFragColor;
uniform float uOpacity;
uniform vec2 uResolution;
uniform sampler2D uNoiseTex;
uniform float uAlpha;
uniform float uQuality;
#define OCTAVES 5
#define TwinkleInterval 40.
const float PI = 3.1415926;
const float PI2 = 6.2831852;

vec2 rand2(vec2 p) {
    p = vec2(dot(p, vec2(12.9898, 78.233)), dot(p, vec2(26.65125, 83.054543)));
    return fract(sin(p) * 43758.5453);
}

float perlinNoise(vec2 v) {
    vec2 i = floor(v);
    vec2 f = fract(v);

    float n00 = dot(texture(uNoiseTex, i * 0.05).xy - 0.5, f);
    float n01 = dot(texture(uNoiseTex, (i + vec2(0.0, 1.0)) * 0.05).xy - 0.5, f - vec2(0.0, 1.0));
    float n10 = dot(texture(uNoiseTex, (i + vec2(1.0, 0.0)) * 0.05).xy - 0.5, f - vec2(1.0, 0.0));
    float n11 = dot(texture(uNoiseTex, (i + vec2(1.0, 1.0)) * 0.05).xy - 0.5, f - vec2(1.0, 1.0));
    vec2 u = smoothstep(0., 1., f);

    return mix(mix(n00, n10, u.x), mix(n01, n11, u.x), u.y) * 10.;
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 0.66666666, 0.33333333, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float drawStars(in vec2 starCoord, float numCells, float size, float br, bool showGlow) {
    vec2 bigCoord = starCoord * numCells;
    vec2 cellID = floor(bigCoord);

    vec2 randvec2 = rand2(mod((cellID), numCells));
    vec2 centerOffset = randvec2 * 0.7 + randvec2.x * 0.3;
    vec2 center = cellID + (showGlow ? mix(vec2(0.1), vec2(0.9), centerOffset) : mix(vec2(0.01), vec2(0.99), centerOffset));
    vec2 offset = bigCoord - center;
    offset *= 1. / (numCells * size);

    float d = dot(offset, offset);

    if (d > 0.16 || !showGlow && d > 0.0025)return 0.;
    float sqrtd = 1. - sqrt(d);
    float starColor = br * (smoothstep(.95, 1., sqrtd));
    starColor *= (1.2 + sin(center.y * 10. + center.x * 71.9 + utime * 2.) * 0.6);
    if (showGlow) {
        float totalGlow = 0.;
        float bigGlowColor = br * (smoothstep(0.6, 1., sqrtd));
        bigGlowColor = pow(clamp(bigGlowColor, 0., 2.), 3.5) * 0.016666667;
        totalGlow = bigGlowColor;

        float angle = atan(offset.y, offset.x) + PI * 0.25;
        float angleOffset = abs(mod(angle, PI * 0.5) - (PI * 0.25));
        float length = mix(0.76, 0.88, pow(angleOffset, 0.5) / (PI * 0.25));
        float rayGlowColor = /* br *  */(smoothstep(length + 0.05, 1.1, sqrtd)) * 0.5;
        totalGlow += rayGlowColor;

        if (sqrtd > 0.895) {
            float smallGlowColor = br * (smoothstep(0.895, 1., sqrtd));
            smallGlowColor = pow(clamp(smallGlowColor, 0., 2.), 2.) * 0.33333333;
            totalGlow += smallGlowColor;
        }

        float t = center.y * 721.3 + center.x * 37.1 + utime * 2.;
        float tWait = (mod(t, (2. + TwinkleInterval) * PI) <= PI2) ? mod(t, PI2) : PI2;
        tWait -= PI * 0.5;
        totalGlow *= (0.5 + sin(tWait) * 0.5);
        return starColor + totalGlow;
    } else {
        return starColor;
    }
}

float fractalNoise(in vec2 coord, in float persistence, in float lacunarity) {
    float n = 0.;
    float frequency = 1.;
    float amplitude = 1.;
    for (int i = 0; i < OCTAVES; ++i)
    {
        n += amplitude * perlinNoise(coord * frequency * 2.);
        amplitude *= persistence;
        frequency *= lacunarity;
    }
    return n;
}

vec4 weatherEffect(vec2 uv) {
    vec2 coord = uv;
    coord = coord * 2. - 1.;
    coord.x *= uResolution.x / uResolution.y;
    vec3 result = vec3(0.);
    float starAlpha = mix(0., 1., smoothstep(0.2, 0.6, uv.y));
    vec2 starCoord = coord + starcoorduv;
    result += drawStars(starCoord, 4., 0.08, 2., true) * vec3(0.74, 0.74, 0.74) * starAlpha;
    result += drawStars(starCoord, 8., 0.05, 1., false) * vec3(0.97, 0.74, 0.74) * starAlpha;
    if (uQuality > 0.) {
        result += drawStars(starCoord, 16., 0.025, 0.5, false) * vec3(0.9, 0.9, 0.95) * starAlpha;
    }
    return vec4(result * uAlpha, 1.);
}
void main() {
    vec2 uv = vUv;
    vec4 col = weatherEffect(uv);
    col.a *= uOpacity;
    oFragColor = col;
}
