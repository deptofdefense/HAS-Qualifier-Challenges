// ----- boiler-plate code for vertex shader to calculate light direction
//       vector and light strength factor

// NB previous define: modelviewmatrix, vertex, lightVector, unif, lightFactor, normout, normal

  vec4 relPosn = modelviewmatrix[0] * vec4(vertex, 1.0);
  vertPosn = vec3(relPosn) / relPosn.w;
  normalVector = vec3(modelviewmatrix[3] * vec4(normal, 0.0));
 
  if (unif[7][0] == 1.0) {                  // this is a point light and unif[8] is location
    lightVector = vertPosn - unif[8];
    lightFactor = pow(length(lightVector), -2.0);
    lightVector = normalize(lightVector);
    lightVector.z *= -1.0;
  } else {                                  // this is directional light
    lightVector = normalize(unif[8]);
    lightFactor = 1.0;
  }

  vec3 reflectDir = reflect(-lightVector, normalVec);
  vec3 viewDir = normalize(-vertPosn);

