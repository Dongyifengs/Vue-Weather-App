#version 300 es
uniform mat4 uMatrix;
uniform float uIntensity;
uniform int uFilter;

in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;
flat out float vtargetAlpha[5];
flat out float vtargetScale[5];
flat out float uIntensity1;
flat out float uIntensity2;
flat out float uIntensity3;
flat out float uIntensity4;
flat out int uFilter1;

#define SCALE_Y 0.028
void main() {
    vUv = aUv;
    gl_Position = uMatrix * vec4(aPosition, 1.0);
    uIntensity1 = uIntensity;
    uIntensity2 = SCALE_Y * mix(1.6, 1., uIntensity / 5.);
    uIntensity3 = mix(1.3, 1.0, uIntensity1);
    uIntensity4 = mix(-2., -5., uIntensity1 / 5.);
    vtargetAlpha = float[5](0.0, 0.0, 0.0, 0.0, 0.0);
    vtargetScale = float[5](0.0, 0.0, 0.0, 0.0, 0.0);
    uFilter1 = uFilter;
    for (int i = 1; i < 6; i++) {
        if (uFilter >= 0) {
            if (i > abs(uFilter))
            continue;
        } else {
            if (i <= abs(uFilter))
            continue;
        }
        vtargetAlpha[i - 1] = 0.35 - float(i - 1) * mix(0.1, 0.05, uIntensity / 5.);
        vtargetScale[i - 1] = 2.5 + float(i - 1) * 1.5;
    }
}