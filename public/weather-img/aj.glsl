#version 300 es
precision highp float;
uniform mat4 uMatrix;
uniform vec2 uResolution;
uniform float uScale;
uniform float uTime;
uniform float uSpeed1;
uniform float uSpeed2;
in vec3 aPosition;
in vec2 aUv;

out vec2 vUv;
out vec2 st;
out vec2 slow;
out vec2 fast;
out float alpha;

void main() {

    st = aUv;
    st.y *= uResolution.y / uResolution.x;
    st = st * 2. - 1.;
    st *= uScale;
    st.y *= 1.1;
    float slowf = uTime * uSpeed1;
    float fastf = uTime * uSpeed2;
    slow = vec2(slowf, 0.);
    slow += st;
    fast = vec2(sin(fastf) * 0.1, 0.);
    fast = st - fast;

    vUv = aUv;
    gl_Position = uMatrix * vec4(aPosition, 1.0);
}