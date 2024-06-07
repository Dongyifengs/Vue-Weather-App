#version 300 es
precision mediump float;

in vec2 vUv;
out vec4 fragColor;
uniform vec2 uResolution;
uniform float uSmooth;
uniform float uGradient;
uniform float uProgress;
uniform float uOpacity;
uniform float uFade;
uniform float uOffsetX;
uniform sampler2D uTex;

float smix(float from, float to, float per, float powVal) {
    if (powVal >= 0.)
    return mix(from, to, pow(per, abs(powVal)));
    else
    return mix(from, to, 1. - pow(1. - per, abs(powVal)));
}

float smix(float from, float to, float per) {
    return smix(from, to, per, 1.);
}

vec4 weatherEffect(vec2 uv) {

    vec2 st = uv;
    st.y = 1. - st.y;
    st = st - 0.5;
    st.x *= uResolution.x/uResolution.y;
    st += 0.5;
    st.x -= uOffsetX;

    vec4 col;
    col = texture(uTex, st);

    float smoothPos = uSmooth;
    float endPos = 1. - uProgress * (1. + smoothPos);
    float startPos = endPos + smoothPos;

    float gradient = uGradient;
    float depth = smoothstep(startPos, endPos, uv.y);

    float fade = min(uFade, uProgress);

    depth += 1. - fade;

    float alpha = smoothstep(depth, depth + gradient, col.r);
    float baseAlpha = pow(smoothstep(0., 1., 1. - depth), 2.) * fade;

    col.a = max(baseAlpha, alpha);

    return col;
}

void main() {
    vec2 uv = vUv;

    vec4 effect = weatherEffect(uv);
    effect.a *= uOpacity;

    fragColor = effect;
}