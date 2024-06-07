#version 300 es
precision lowp float;

in vec2 vUv;
out vec4 oFragColor;

uniform float uTime;

uniform vec3 uSunPos;
uniform vec3 uGroundPos;
uniform vec3 uAmbientPos;
uniform vec3 uLamp1Pos;
uniform vec3 uLamp2Pos;

uniform float uSunIntensity;
uniform float uGroundIntensity;
uniform float uAmbientIntensity;
uniform float uLamp1Intensity;
uniform float uLamp2Intensity;

uniform vec4 uCloudColor;
uniform vec4 uSunColor;
uniform vec4 uGroundColor;
uniform vec4 uAmbientColor;
uniform vec4 uLamp1Color;
uniform vec4 uLamp2Color;

uniform vec4 uInnerColor;
uniform float uInnerIntensity;

uniform float uProgress;
uniform float uReverse;
uniform float uSmooth;
uniform float uAlpha;

uniform float uLod;

uniform float uDebug;

uniform sampler2D uTex;

uniform float uStartEdge;
uniform float uEndEdge;

uniform float uStartBottomAlpha;
uniform float uEndBottomAlpha;

uniform vec4 uSkyColor;
uniform float uFog;
uniform float uFogDensity;
uniform int uNoiseFlag;
uniform sampler2D uCloudNoiseTex;
uniform float uCloudScale;

#define NUM_OCTAVES 5

float perFromVal(float val, float from, float to) {
    return (val - from) / (to - from);
}

float matchAlphaToAlpha(float curAlpha, float tarAlpha) {
    return (tarAlpha - curAlpha) / (1. - curAlpha);
}

vec4 texelNormal(vec2 uv) {
    uv.y /= 2.;
    vec4 col = texture(uTex, uv);
    col = col * 2. - 1.;
    return col;
}

vec4 texelAlphaDepthInner(vec2 uv) {
    uv.y /= 2.;
    uv.y += 1. / 2.;
    vec4 col = texture(uTex, uv);
    col.r *= step(0.5, uv.y);
    return vec4(col.rgb, 1.);
}

float brightness(vec3 norm, vec3 lightPos, float intensity) {

    lightPos.xz -= (0.5 - vUv) * 2.16 * uCloudScale / 3.;
    float strength = intensity / (dot(lightPos, lightPos));
    strength = clamp(strength, 0., 8.);
    vec3 direction = normalize(lightPos);
    float light = (dot(direction.xyz, norm.xyz));

    return clamp(light * strength, 0., 1.);
}

void main() {
    vec4 col = texelAlphaDepthInner(vUv);
    float alp = col.r;
    float dep = col.g;
    vec2 nxy = vec2(0.);
    float n = 0.;
    if (uNoiseFlag == 1) {
        vec4 cloudNoise = texture(uCloudNoiseTex, vUv);
        nxy = cloudNoise.xy;
        n = cloudNoise.z;
    }

    vec2 texCoord = vUv.xy + nxy * mix(0.025, 0.03, dep);

    vec4 alphaDepthInner = texelAlphaDepthInner(texCoord);

    float alpha = alphaDepthInner.r;

    if (alpha <= 0.) {
        oFragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    vec3 norm = texelNormal(texCoord).rgb;
    float depth = alphaDepthInner.g;
    float inner = alphaDepthInner.b;

    vec3 sunPos = uSunPos;
    vec3 groundPos = uGroundPos;
    vec3 ambientPos = uAmbientPos;
    vec3 lamp1Pos = uLamp1Pos;
    vec3 lamp2Pos = uLamp2Pos;

    float bSun = brightness(norm, sunPos, uSunIntensity);
    float bGround = brightness(norm, groundPos, uGroundIntensity);
    float bAmbient = brightness(norm, ambientPos, uAmbientIntensity);
    float bLamp1 = brightness(norm, lamp1Pos, uLamp1Intensity);
    float bLamp2 = brightness(norm, lamp2Pos, uLamp2Intensity);

    float maxIntensity = max(max(max(uSunIntensity, uGroundIntensity), uAmbientIntensity), max(uLamp1Intensity, uLamp2Intensity));
    float bInner = (smoothstep(0., 0.1, inner) + 0.5) * uInnerIntensity;

    vec4 skyColor = uSkyColor;
    vec4 cloudColor = uCloudColor;
    vec4 lamp2Color = uLamp2Color;
    vec4 lamp1Color = uLamp1Color;
    vec4 ambientColor = uAmbientColor;
    vec4 groundColor = uGroundColor;
    vec4 sunColor = uSunColor;

    vec4 color = cloudColor;
    color.rgb = mix(color.rgb, lamp2Color.rgb, bLamp2);
    color.rgb = mix(color.rgb, lamp1Color.rgb, bLamp1);
    color.rgb = mix(color.rgb, ambientColor.rgb, bAmbient);
    color.rgb = mix(color.rgb, groundColor.rgb, bGround);
    color.rgb = mix(color.rgb, sunColor.rgb, bSun);

    color.rgb = mix(color.rgb, skyColor.rgb, smoothstep(0., 0.1, inner) * 0.3);

    color.rgb += groundColor.rgb * bGround * 0.1;
    color.rgb += sunColor.rgb * bSun * (1. - clamp(uSunIntensity / 100., 0., 1.)) * 0.4;

    color.rgb += uInnerColor.rgb * bInner;

    color.rgb = mix(color.rgb, skyColor.rgb, uFogDensity * uFog);

    float bottom = smoothstep(uStartBottomAlpha, uEndBottomAlpha + 0.3, 1.0 - vUv.y);
    float edge = smoothstep(uEndEdge, uStartEdge, depth - 0.03 * (1.0 - bottom));
    alpha -= edge * edge + edge * n * 0.8;


    alpha *= smoothstep(uStartBottomAlpha, uEndBottomAlpha, 1.0 - vUv.y);

    if (uNoiseFlag == 1) {
        float nDepth = smoothstep(0., 1., n) * edge;
        alpha -= nDepth + (1. - alpha) * n;
    }

    alpha *= uAlpha;
    alpha = clamp(alpha, 0., 1.);

    float per = (1. + uSmooth) - clamp(uProgress, 0., 1.);
    float depthAlpha = clamp(perFromVal(depth, per - uSmooth, per), 0., 1.);

    bool reverse = uReverse == 1.;
    alpha *= reverse ? matchAlphaToAlpha(alpha * depthAlpha, alpha) : alpha * depthAlpha;

    color.a = alpha;
    oFragColor = color;
    return;
}