#version 140

//uniform sampler2D texture0;

in vec3 color;

out vec4 FragColor;

void main()
{
  FragColor.rgb = color;
  //FragColor.rgb *= 1 - texture(texture0, gl_FragCoord.xy * 0.1).r;
}
