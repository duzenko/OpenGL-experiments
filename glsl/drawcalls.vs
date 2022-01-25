#version 430

layout(location = 0) uniform int instanceID;

out vec3 color;

void main() {
	color = sin(instanceID * vec3(3,4,5)) * 0.3 + 0.7;
  gl_Position.x = gl_VertexID % 2;
  gl_Position.y = gl_VertexID / 2;
  gl_Position.z = 0;
  gl_Position.w = 1;
  gl_Position.xy *= 6e-2;
  gl_Position.x += instanceID % 10 * 0.1 - .9;
  gl_Position.y += instanceID / 10 * 0.1;
}
