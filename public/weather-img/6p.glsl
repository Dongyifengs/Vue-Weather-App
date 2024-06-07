#version 300 es
uniform mat4 uMatrix;
uniform float uLife;
uniform float uInterval;
uniform float uTime;

in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;
out float starID;
out float curtTime;
out float uLife1;

void main() {
    vUv = aUv;
    gl_Position = uMatrix * vec4(aPosition, 1.0);
    starID = floor(uTime / (uLife + uInterval));
    curtTime = mod(uTime, (uLife + uInterval));
    uLife1 = uLife;
}
