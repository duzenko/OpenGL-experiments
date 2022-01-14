#version 150 core

in vec4 position;

out vec3 color;

void main()
{
#if 1
  gl_Position = position;
  gl_Position.xyz *= 3e-2;
  gl_Position.x += gl_InstanceID % 10 * 0.1 - .9;
  gl_Position.y += gl_InstanceID / 10 * 0.1;
#else
  gl_Position.zw = vec2(0, 1);
  gl_Position.x = gl_VertexID % 18 * 1e-2;
  gl_Position.y = gl_VertexID % 2 * 3e-2;
#endif
  color = sin(gl_InstanceID * vec3(3, 4, 5) * 1e-0) * 0.3 + vec3(0.7);
}

