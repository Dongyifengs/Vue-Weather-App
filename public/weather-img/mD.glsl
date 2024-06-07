#version 300 es
precision highp float;
in vec2 vUv;
out vec4 oFragColor;

uniform sampler2D uTex;

uniform vec4 uColPos1;
uniform vec4 uColPos2;
uniform vec4 uColPos3;
uniform vec4 uColPos4;
uniform vec4 uColPos5;

uniform vec4 uBlendColor;
uniform float uLab;

uniform float uAlpha;
uniform float uWhiteAlpha;

uniform float uClipRate;
uniform vec2 uResolution;

float blendLinearDodge(float base, float blend) {
    return min(base + blend, 1.0);
}

float blendLinearBurn(float base, float blend) {
    return max(base + blend - 1.0, 0.0);
}

float blendLinearLight(float base, float blend) {
    return blend < 0.5 ? blendLinearBurn(base, (2.0 * blend)) : blendLinearDodge(base, (2.0 * (blend - 0.5)));
}

vec3 blendLinearLight(vec3 base, vec3 blend) {
    return vec3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
}

vec3 blendLinearLight(vec3 base, vec3 blend, float opacity) {
    return (blendLinearLight(base, blend) * opacity + base * (1.0 - opacity));
}

vec4 blendLinearLight(vec4 blend, vec4 base) {
    vec3 baseOver = blendLinearLight(base.rgb, blend.rgb, blend.a);
    float alpha = base.a;
    return vec4(baseOver, alpha);
}

vec3 rgb2xyz(vec3 color) {

    if (color.r > 0.04045) {
        color.r = pow(((color.r + 0.055) / 1.055), 2.4);
    } else {
        color.r = color.r / 12.92;
    }

    if (color.g > 0.04045) {
        color.g = pow(((color.g + 0.055) / 1.055), 2.4);
    } else {
        color.g = color.g / 12.92;
    }

    if (color.b > 0.04045) {
        color.b = pow(((color.b + 0.055) / 1.055), 2.4);
    } else {
        color.b = color.b / 12.92;
    }

    color = color * 100.0;

    vec3 xyz;
    xyz.x = color.r * 0.4124 + color.g * 0.3576 + color.b * 0.1805;
    xyz.y = color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722;
    xyz.z = color.r * 0.0193 + color.g * 0.1192 + color.b * 0.9505;

    return xyz;
}

vec3 xyz2lab(vec3 color) {
    vec3 white = vec3(95.047, 100.000, 108.883);
    color = color / white;

    if (color.x > 0.008856) {
        color.x = pow(color.x, 1.0 / 3.0);
    } else {
        color.x = (7.787 * color.x) + (16.0 / 116.0);
    }

    if (color.y > 0.008856) {
        color.y = pow(color.y, 1.0 / 3.0);
    } else {
        color.y = (7.787 * color.y) + (16.0 / 116.0);
    }

    if (color.z > 0.008856) {
        color.z = pow(color.z, 1.0 / 3.0);
    } else {
        color.z = (7.787 * color.z) + (16.0 / 116.0);
    }

    vec3 lab;
    lab.x = (116.0 * color.y) - 16.0;
    lab.y = 500.0 * (color.x - color.y);
    lab.z = 200.0 * (color.y - color.z);

    return lab;
}

vec3 rgb2lab(vec3 color) {
    return xyz2lab(rgb2xyz(color));
}

vec3 lab2xyz(vec3 lab) {
    float y = (lab.x + 16.0) / 116.0;
    float x = lab.y / 500.0 + y;
    float z = y - lab.z / 200.0;

    if (pow(y, 3.0) > 0.008856) {
        y = pow(y, 3.0);
    } else {
        y = (y - 16.0 / 116.0) / 7.787;
    }

    if (pow(x, 3.0) > 0.008856) {
        x = pow(x, 3.0);
    } else {
        x = (x - 16.0 / 116.0) / 7.787;
    }

    if (pow(z, 3.0) > 0.008856) {
        z = pow(z, 3.0);
    } else {
        z = (z - 16.0 / 116.0) / 7.787;
    }

    vec3 white = vec3(95.047, 100.000, 108.883);
    vec3 xyz = vec3(x * white.x, y * white.y, z * white.z);

    return xyz;
}

vec3 xyz2rgb(vec3 xyz) {
    xyz = xyz / 100.0;

    float r = xyz.x * 3.2406 + xyz.y * -1.5372 + xyz.z * -0.4986;
    float g = xyz.x * -0.9689 + xyz.y * 1.8758 + xyz.z * 0.0415;
    float b = xyz.x * 0.0557 + xyz.y * -0.2040 + xyz.z * 1.0570;

    if (r > 0.0031308) {
        r = 1.055 * pow(r, (1.0 / 2.4)) - 0.055;
    } else {
        r = 12.92 * r;
    }

    if (g > 0.0031308) {
        g = 1.055 * pow(g, (1.0 / 2.4)) - 0.055;
    } else {
        g = 12.92 * g;
    }

    if (b > 0.0031308) {
        b = 1.055 * pow(b, (1.0 / 2.4)) - 0.055;
    } else {
        b = 12.92 * b;
    }

    r = clamp(r, 0.0, 1.0);
    g = clamp(g, 0.0, 1.0);
    b = clamp(b, 0.0, 1.0);

    return vec3(r, g, b);
}

vec3 lab2rgb(vec3 lab) {
    return xyz2rgb(lab2xyz(lab));
}

vec4 labLighten(vec4 color, float a) {
    vec3 lab = rgb2lab(color.rgb);
    lab.r = (100. - a) / 55. * lab.r + (100. * a - 4500.) / 55.;
    return vec4(lab2rgb(lab), color.a);
}

vec4 labDarken(vec4 color, float a) {
    vec3 lab = rgb2lab(color.rgb);
    lab.r = a / 45. * lab.r;
    return vec4(lab2rgb(lab), color.a);
}

vec3 getCol(vec3 col1, vec3 col2, float rate) {
    vec3 lab = mix(col1, col2, clamp(rate, 0., 1.));
    return lab;
}

vec3 gammaCorrect(vec3 col, float gamma) {
    return pow(col, vec3(gamma));
}

float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec3 col = vec3(vUv.y);

    if (uLab > 0.) {
        vec2 uv = vec2(vUv.x, 1. - vUv.y);
        float y = 1. - gl_FragCoord.y / uResolution.y;

        if (y < uColPos1.w) {
            col = uColPos1.rgb;
        } else if (y < uColPos2.w) {
            col = getCol(uColPos1.rgb, uColPos2.rgb, (y - uColPos1.w) / (uColPos2.w - uColPos1.w));
        } else if (y < uColPos3.w) {
            col = getCol(uColPos2.rgb, uColPos3.rgb, (y - uColPos2.w) / (uColPos3.w - uColPos2.w));
        } else if (y < uColPos4.w) {
            col = getCol(uColPos3.rgb, uColPos4.rgb, (y - uColPos3.w) / (uColPos4.w - uColPos3.w));
        } else if (y < uColPos5.w) {
            col = getCol(uColPos4.rgb, uColPos5.rgb, (y - uColPos4.w) / (uColPos5.w - uColPos4.w));
        } else {
            col = uColPos5.rgb;
        }

        if (uv.y < uClipRate) {
            oFragColor = vec4(0.0);
        } else {
            vec4 tex = texture(uTex, uv);

            col = gammaCorrect(col, 1.1);
            col = blendLinearLight(uBlendColor, vec4(col, 1.)).rgb;
            col = labLighten(vec4(col, 1.), 0.55 * uLab * 100. + 45.).rgb;
            oFragColor = vec4(col, tex.a * uAlpha);
        }
    } else {
        float y = 1. - vUv.y;

        if (y < uColPos1.w) {
            col = uColPos1.rgb;
        } else if (y < uColPos2.w) {
            col = getCol(uColPos1.rgb, uColPos2.rgb, (y - uColPos1.w) / (uColPos2.w - uColPos1.w));
        } else if (y < uColPos3.w) {
            col = getCol(uColPos2.rgb, uColPos3.rgb, (y - uColPos2.w) / (uColPos3.w - uColPos2.w));
        } else if (y < uColPos4.w) {
            col = getCol(uColPos3.rgb, uColPos4.rgb, (y - uColPos3.w) / (uColPos4.w - uColPos3.w));
        } else if (y < uColPos5.w) {
            col = getCol(uColPos4.rgb, uColPos5.rgb, (y - uColPos4.w) / (uColPos5.w - uColPos4.w));
        } else {
            col = uColPos5.rgb;
        }

        float n = noise(vUv * 20.0);
        col = mix(col - vec3(1.0 / 255.0), col + vec3(2.0 / 255.0), n);

        oFragColor = vec4(col, 1.0);
    }
}