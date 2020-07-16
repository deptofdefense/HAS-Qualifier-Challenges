#include std_head_fs.inc

varying vec2 texcoordout;
varying vec3 vertPos;
varying vec3 normalVector;
varying vec3 lightVector;
varying float lightFactor;

void main() {

  vec4 texc = texture2D(tex0, texcoordout); // ------ material or basic colour from texture
  if (texc.a < unib[0][2]) discard; // ------ to allow rendering behind the transparent parts of this object
  texc.rgb += unib[1] - vec3(0.5);

  vec3 normnorm = normalize(normalVector);
  vec3 reflectDir = reflect(-lightVector, normnorm);
  vec3 viewDir = normalize(-vertPos);

  float lambertian = max(dot(lightVector, normnorm), 0.0) * lightFactor;
  float specAngle = max(dot(reflectDir, viewDir), 0.0);
  float specular = pow(specAngle, 4.0) * lightFactor;

  texc.rgb *= unif[9] * (lambertian + specular)  + unif[10]; // ------ directional lightcol * intensity + ambient lightcol

  gl_FragColor = texc;
}


