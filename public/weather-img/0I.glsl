#version 300 es
precision lowp float;
uniform mat4 uMatrix;
uniform float uTime;
uniform float uCircleRandom;
uniform float uSunPosOffsetY;
uniform vec2 uSunPos;
uniform vec2 uResolution;
uniform float uLineAlpha;
in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;
out vec4 light;
out float circleNumber;
out float randSeed;
out vec2 sunPos;
#define LINE_SPEED 0.5
#define LINE_COLOR vec4(1.0, 0.8078, 0.3922, 1.0)
#define PI 3.1415926

float getRandom(float value, float seed) {
    return fract(sin(value * 999.9) * seed);
}

void main() {

    sunPos = uSunPos.xy;
    sunPos.x += uSunPosOffsetY * sunPos.x;
    sunPos.y += uSunPosOffsetY;
    sunPos.x *= uResolution.x / uResolution.y;
    float time = sin(uTime * 0.3333 + 5.) * 0.05;
    float lightTime = (sin(uTime * LINE_SPEED * 4.) + 1.) * 0.5;
    float lightTime2 = (sin((uTime * LINE_SPEED + PI * 0.3333) * 4.) + 1.) * 0.5;
    float lightTime3 = (sin((uTime * LINE_SPEED + PI * 0.6667) * 4.) + 1.) * 0.5;
    circleNumber = floor(mix(4., 8., getRandom(17., uCircleRandom / 100000. * 67.9)));
    randSeed = uCircleRandom / 100000. * 939.7;
    light = vec4(lightTime, lightTime2, lightTime3, time);
    light.rgb *= LINE_COLOR.rgb * (uLineAlpha / 320.);

    vUv = aUv - 0.5;
    vUv.x *= uResolution.x / uResolution.y;
    gl_Position = uMatrix * vec4(aPosition, 1.0);
}