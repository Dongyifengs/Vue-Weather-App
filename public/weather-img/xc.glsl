#version 300 es
uniform mat4 uMatrix;
uniform float uTime;

in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;
out vec2 starcoorduv;
out vec2 cloudCoord1uv;
out float utime;
out float sintime;

void main() {
    vUv = aUv;
    gl_Position = uMatrix * vec4(aPosition, 1.0);
    starcoorduv = vec2(10. + uTime * 0.002, 0.5);
    cloudCoord1uv = (uTime + 113.) * 0.1 * vec2(1., 0.5) * 0.2;
    sintime = 0.5 + 0.5 * sin(uTime * 0.1);
    utime = uTime;
}