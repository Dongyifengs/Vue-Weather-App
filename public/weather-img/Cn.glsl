#version 300 es
precision highp float;

in vec2 vUv;
out vec4 oFragColor;

uniform float uOpacity;
uniform vec4 uTopCol;
uniform vec4 uBottomCol;
uniform float uBright;
uniform float uHeight;

void main() {
    vec4 color = mix(uBottomCol, uTopCol, vUv.y);
    color.a *= smoothstep(1. - uHeight, 1., uBright);
    oFragColor = vec4(color.rgb, color.a * uOpacity);
}