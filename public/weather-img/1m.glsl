#version 300 es
uniform mat4 uMatrix;
uniform vec2 uResolution;

in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;

void main() {
    vUv = aUv;
    float aRatio = uResolution.x / uResolution.y;
    vec4 tPosition = uMatrix * vec4(aPosition, 1.0);
    tPosition.y = tPosition.y * aRatio + 1.0 - aRatio;
    gl_Position = tPosition;
}
