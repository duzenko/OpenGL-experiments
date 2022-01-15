#version 140

in vec3 color;

out vec4 FragColor;

void main()
{
  FragColor.rgb = color;
}
