program Project1;

{$mode objfpc}{$H+}

uses gl, glfw336, GLext;

var
  window: pGLFWwindow;

procedure keyFunc(p: pGLFWWindow; i2, i3, i4, i5: longint); cdecl;
begin
  if(i2=256) then
    glfwSetWindowShouldClose(window, 1);
end;

const
  vertices: array[1..6] of Single = (
    0, 0,
    0, 1e-2,
    1e-2, 1e-2
  );
  IndexSize = 1000;
var
  i, j: integer;
  indices: array[1..IndexSize, 0..2] of Integer;
begin
  for i:=1 to IndexSize do
    for j:=0 to 2 do
      indices[i, j] := j;
  glfwInit;
  window := glfwCreateWindow(1280, 800, '', nil, nil);
  glfwMakeContextCurrent( window );
  Load_GL_version_1_5;
  glfwSetKeyCallback(window, @keyFunc);
  glfwSwapInterval(0);
  glBindBuffer(GL_ARRAY_BUFFER, 1);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), @vertices, GL_STATIC_DRAW);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 2);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), @indices, GL_STATIC_DRAW);
  glEnableClientState(GL_VERTEX_ARRAY);
  glVertexPointer(2, GL_FLOAT, 0, nil);
  repeat
    glClear(GL_COLOR_BUFFER_BIT);
    for i:=1 to 1000 do begin
      glDrawElements(GL_TRIANGLES, 3*IndexSize, GL_UNSIGNED_INT, nil);
    end;
    glfwSwapBuffers(window);
    glfwPollEvents;
  until glfwWindowShouldClose(window) <> 0;
  glfwTerminate;
end.

