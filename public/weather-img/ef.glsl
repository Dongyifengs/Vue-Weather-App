precision mediump float;
uniform sampler2D uBlurTexture;
varying vec2 vBlurTexCoords[5];

void main()
{
    vec4 sum = vec4(0.0);
    sum += texture2D(uBlurTexture, vBlurTexCoords[0]) * 0.164074;
    sum += texture2D(uBlurTexture, vBlurTexCoords[1]) * 0.216901;
    sum += texture2D(uBlurTexture, vBlurTexCoords[2]) * 0.23805;
    sum += texture2D(uBlurTexture, vBlurTexCoords[3]) * 0.216901;
    sum += texture2D(uBlurTexture, vBlurTexCoords[4]) * 0.164074;
    gl_FragColor = sum;
}
