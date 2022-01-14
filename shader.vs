#version 150 core

in vec4 position;

void main()
{
  gl_Position.zw = vec2(0, 1);
  gl_Position.x = gl_VertexID % 18 * 1e-2;
  gl_Position.y = gl_VertexID % 2 * 3e-2;
}

