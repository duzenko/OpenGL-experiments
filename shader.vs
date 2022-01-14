#version 150 core

in vec4 position;

void main()
{
#if 1
  gl_Position = position;
  gl_Position.xyz *= 3e-2;
  gl_Position.x += gl_InstanceID * 0.1 - .8;
#else
  gl_Position.zw = vec2(0, 1);
  gl_Position.x = gl_VertexID % 18 * 1e-2;
  gl_Position.y = gl_VertexID % 2 * 3e-2;
#endif
}

