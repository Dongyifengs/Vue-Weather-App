attribute vec4 aPosition;
attribute vec2 aTexCoord;
uniform float uBlurBufferSize;
varying vec2 vTexCoord;
varying vec2 vBlurTexCoords[5];
void main() {
    gl_Position = aPosition;
    vTexCoord = aTexCoord;
    vBlurTexCoords[0] = vTexCoord + vec2(-0.7 * uBlurBufferSize, 0.0);
    vBlurTexCoords[1] = vTexCoord + vec2(-0.35 * uBlurBufferSize, 0.0);
    vBlurTexCoords[2] = vTexCoord;
    vBlurTexCoords[3] = vTexCoord + vec2( 0.35 * uBlurBufferSize, 0.0);
    vBlurTexCoords[4] = vTexCoord + vec2( 0.7 * uBlurBufferSize, 0.0);
}
