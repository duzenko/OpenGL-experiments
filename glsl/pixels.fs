#version 120

uniform sampler2D textures[8];
uniform int instanceID;
uniform int textureCount;

void main() {
  gl_FragColor.a = 0.5;
  gl_FragColor.rg = fract(gl_FragCoord.xy * 1e-1 / ( 1 + instanceID ) );
  if(textureCount < 1) return;
  for( int i=0; i<textureCount; i++)
    gl_FragColor.b += texture2D(textures[i], gl_FragCoord.xy * 3e-3 * (i+1)).r;
  gl_FragColor.b /= textureCount;
}
