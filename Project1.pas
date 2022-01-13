program Project1;

uses gl, GLext, SysUtils, classes, wrappers;

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
  with TGlfwWindow.Create do try
    TGlBuffer.Create(GL_ARRAY_BUFFER, @vertices, sizeof(vertices));
    TGlBuffer.Create(GL_ELEMENT_ARRAY_BUFFER, @indices, sizeof(indices));
    TGlProgram.Create('shader');
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, nil);
    repeat
      glClear(GL_COLOR_BUFFER_BIT);
      for i := 1 to 1000 do begin
        glDrawElements(GL_TRIANGLES, 3*IndexSize, GL_UNSIGNED_INT, nil);
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end.

