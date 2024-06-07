attribute vec4 aPosition;
attribute vec2 aTexCoord;
uniform mat4 uMvpTransform;
varying vec2 vTexCoord;

void main() {
    gl_Position = uMvpTransform * aPosition;
    vTexCoord = aTexCoord;
}
