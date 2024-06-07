precision lowp float;
uniform sampler2D uDiffuseTexture;
uniform float uAlphaThreshold;
varying vec2 vTexCoord;
void main()
{
    gl_FragColor = texture2D(uDiffuseTexture, vTexCoord);
    gl_FragColor.a = (gl_FragColor.a > uAlphaThreshold) ? 0.1 : 0.0;
}
