attribute vec4 aPosition;
attribute vec4 aColor;
attribute float aWeight;
uniform mat4 uTransform;
uniform float uPointSize;
uniform vec3 uWeightParams;
varying vec4 vColor;

void main() {
  gl_Position = uTransform * aPosition;
  gl_PointSize = uPointSize;
  vColor = aColor;
  float weight = aWeight * aWeight * uWeightParams[0] + uWeightParams[1];
  vColor.rgb *= (weight > uWeightParams[2]) ? 1.0 / weight : 1.0;
}
