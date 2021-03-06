#include std_head_vs.inc

varying vec2 texcoordout;
varying vec2 bumpcoordout;
varying vec3 lightVector;
varying float lightFactor;
varying float texFactor;

void main(void) {
  vec3 normout;
#include std_main_vs.inc
  texcoordout = fract(texcoord * unib[2].xy + unib[3].xy);
  bumpcoordout = texcoordout * vec2(1.0, 1.0) * unib[0][0];
  texFactor = floor(texcoord[0]); // ----- u and v expected to go up together!

  vec3 inray = vec3(relPosn - vec4(unif[6], 0.0)); // ----- vector from the camera to this vertex
  dist = length(inray);
#include std_fog_start.inc

  gl_Position = modelviewmatrix[1] * vec4(vertex,1.0);
  gl_PointSize = unib[2][2] / dist;
}
