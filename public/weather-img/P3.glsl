#version 300 es
precision mediump float;
in vec2 vUv;

uniform float uOpacity;
uniform sampler2D uTex;

out vec4 oFragColor;

void main() {
    oFragColor = vec4(vec3(texture(uTex, vUv)), 1.0);
}