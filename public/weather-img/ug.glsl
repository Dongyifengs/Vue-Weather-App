#version 300 es
precision mediump float;
in vec2 vUv;

uniform float uOpacity;
uniform sampler2D uTex;

out vec4 oFragColor;

void main() {
    vec4 color = texture(uTex, vUv);
    color.a *= uOpacity;
    oFragColor = color;
}