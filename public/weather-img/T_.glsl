#version 300 es
precision highp float;

in vec2 vUv;
out vec4 oFragColor;
uniform float uOpacity;
uniform float uAlpha;
uniform float uTime;
uniform float uSpeedX;
uniform vec2 uResolution;
uniform sampler2D uNoiseTex;
uniform vec3 uColor;
float time = 0.0;

vec2 offz = vec2(20.288, 7.872);

float noise(vec3 x) {
    vec2 uv1 = x.xy + offz * x.z;
    return texture(uNoiseTex, uv1).x - 0.3;
}

float clouds(vec3 p) {
    float b = noise(p) * 0.00002 * 1200.0;
    float x = p.x * 0.3 - ((time) * uSpeedX);

    p = vec3(x, p.y, p.z) * 0.00002;

    float a = 0.0;

    a += noise(p + vec3(0.0, 1.0, 0.0)) * 1.0;
    p *= 2.0;

    a += noise(p + vec3(0.0, 2.0, 0.0)) * 0.8;
    p *= 3.0;

    a += noise(p + vec3(0.0, 3.0, 0.0)) * 0.5;
    p *= 3.0;

    a += noise(p + vec3(0.0, 4.0, 0.0)) * 0.4;
    p *= 3.0;

    a += noise(p + vec3(0.0, 5.0, 0.0)) * 0.2;

    return a;
}

vec4 weatherEffect(vec2 uv) {
    uv.x *= uResolution.x / uResolution.y;

    float alpha = mix(0.,1.,smoothstep(0.45,1.,uv.y)) * uAlpha;
    if(alpha < 0.001){
        return vec4(0.);
    }

    time = uTime * 5.0 + uTime * 0.1 * 150.0;

    vec3 campos = vec3(30.0, 500.0, 0.);
    vec3 ray = normalize(vec3(uv.x, uv.y - 0.1, 1.0).xyz);
    vec3 pos = campos + ray;

    float fog = 0.0;

    for(float i = 20.0; i < 30.0; i+=1.4) {
        fog += max(pos.y * clouds(pos), fog * 0.02);
        pos += vec3(uv, 1.) * min(pos.y, i * i * 0.5);
    }

    vec3 cloudColor = uColor;

    float cloud = sin(fog * 0.002);

    return vec4(cloudColor, cloud * alpha);
}

void main() {
    vec2 uv = vUv;
    vec4 col = weatherEffect(uv);
    col.a *= uOpacity;
    oFragColor = col;
}