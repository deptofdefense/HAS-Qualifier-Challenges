attribute vec3 vertex;
attribute vec3 normal;
attribute vec2 texcoord;

uniform mat4 modelviewmatrix[4]; // [0] model movement in real coords, [1] in camera coords, [2] camera at light
uniform vec3 unib[5];
uniform vec3 unif[20];

varying vec2 texcoordout;
varying vec3 vertPos;
varying vec3 normalVector;
varying vec3 lightVector;
varying float lightFactor;

void main(){
  gl_Position = modelviewmatrix[1] * vec4(vertex, 1.0);

  // all following gemetric computations are performed in the
  // camera coordinate system (aka eye coordinates)
  normalVector = vec3(modelviewmatrix[1] * vec4(normal, 0.0));
  vec4 vertPos4 = modelviewmatrix[0] * vec4(vertex, 1.0);
  vertPos = vec3(vertPos4) / vertPos4.w;
  if (unif[7][0] == 1.0) {                  // this is a point light and unif[8] is location
    lightVector = unif[8] - vertPos;
    lightFactor = pow(length(lightVector), -2.0);
    lightVector = normalize(lightVector);
  } else {                                  // this is directional light
    lightVector = normalize(unif[8]);
    lightFactor = 1.0;
  }
  texcoordout = texcoord * unib[2].xy + unib[3].xy;
}
    