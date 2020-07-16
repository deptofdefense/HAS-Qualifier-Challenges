// ----- boiler-plate code for fragment shader to get lighting

// NB previous define: lightVector, lightFactor, texc, unif
  vec3 normnorm = normalize(normalVector);
  vec3 reflectDir = reflect(-lightVector, normnorm);
  vec3 viewDir = normalize(-vertPosn);

  float lambertian = max(dot(lightVector, normnorm), 0.0);
  float specular = 0.0;

  float specAngle = max(dot(reflectDir, viewDir), 0.0);
  specular = pow(specAngle, 4.0);

  float intensity = clamp((lambertian + specular) * lightFactor, 0.0, 1.0); // ------ adjustment of colour according to combined normal
  texc.rgb = (texc.rgb * unif[9]) * intensity + (texc.rgb * unif[10]); // ------ directional lightcol * intensity + ambient lightcol
