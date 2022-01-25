#version 430

uniform sampler2D texture0;

in vec3 color;

void main() {
  gl_FragColor.rgb = color;
  gl_FragColor.rgb *= 1 - texture(texture0, gl_FragCoord.xy * 1 / 16).r;
}
