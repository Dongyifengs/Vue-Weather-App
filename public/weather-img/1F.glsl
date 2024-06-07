precision lowp float;
uniform sampler2D uDiffuseTexture;
varying vec4 vColor;

void main() {
  gl_FragColor = texture2D(uDiffuseTexture, gl_PointCoord);
  gl_FragColor *= vColor;
}
