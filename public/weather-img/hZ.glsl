#version 300 es
uniform mat4 uMatrix;

in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;

void main() {
    vUv = aUv;
    gl_Position = uMatrix * vec4(aPosition, 1.0);
}
