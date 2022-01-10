program Project1;

{$mode objfpc}{$H+}

uses gl, glfw334;

var
  window: pGLFWwindow;

procedure keyFunc(p: pGLFWWindow; i2, i3, i4, i5: longint); cdecl;
begin
  if(i2=256) then
    glfwSetWindowShouldClose(window, 1);
end;

begin
  glfwInit;
  window := glfwCreateWindow(1280, 800, '', nil, nil);
  glfwMakeContextCurrent( window );
  glfwSetKeyCallback(window, @keyFunc);
  repeat
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin;
    glfwSwapBuffers(window);
    glfwPollEvents;
  until glfwWindowShouldClose(window) <> 0;
  glfwTerminate;
end.

