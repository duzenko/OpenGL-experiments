#version 120

uniform sampler2D texture0;
uniform int instanceID;

void main() {
  gl_FragColor.rg = fract(gl_FragCoord.xy * 1e-1 / ( 1 + instanceID ) );
  gl_FragColor.a = 0.5;
}
