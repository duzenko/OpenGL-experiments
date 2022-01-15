unit test31;

interface uses
  Classes, SysUtils, gl, glext,
  wrappers, sphere;

procedure RunTest31;

implementation

var
	lastTime: TDateTime = 0;
  instances: Integer = 10;
  i: integer;

procedure RunTest31;
begin
  with TGlfwWindow.Create(3.1) do try
    TGlVao.Create();
    TGlBuffer.Create(GL_ARRAY_BUFFER, @SphereVertices, sizeof(SphereVertices));
    TGlBuffer.Create(GL_ELEMENT_ARRAY_BUFFER, @SphereIndices, sizeof(SphereIndices));
    TGlProgram.Create('shader');
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, nil);
    repeat
      if Now - lastTime > 1/86400 then begin
        if lastTime > 0 then begin
          if fps > 60 then
          	Inc(instances);
          if (fps < 30) and (instances > 1) then
          	Dec(instances);
        end;
        lastTime := Now;
      end;
      glClear(GL_COLOR_BUFFER_BIT);
      for i := 1 to 100 do begin
        glDrawElementsInstanced(GL_TRIANGLES, High(SphereIndices), GL_UNSIGNED_INT, nil, instances);
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end;

end.

