unit test15;

interface uses
  Classes, SysUtils, gl, glext,
  wrappers, sphere;

procedure RunTest15;

implementation

var
	lastTime: TDateTime = 0;
  instances: Integer = 10;

procedure RunTest15;
var
  i, j, k: integer;
  color: array[0..2] of Single;
begin
  with TGlfwWindow.Create(1.5) do try
    TGlBuffer.Create(GL_ARRAY_BUFFER, @SphereVertices, sizeof(SphereVertices));
    TGlBuffer.Create(GL_ELEMENT_ARRAY_BUFFER, @SphereIndices, sizeof(SphereIndices));
    glInterleavedArrays(GL_V3F, 0, nil);
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
        for j := 0 to instances - 1 do begin;
          glLoadIdentity;
          glScalef(0.03, 0.03, 0.03);
          glTranslatef((j mod 10 - 9)*3, j div 10 * 3, 0);
          for k := 0 to 2 do
	          color[k] := sin(j * (3+k)) * 0.3 + 0.7;
          glColor3fv(color);
        	glDrawElements(GL_TRIANGLES, High(SphereIndices), GL_UNSIGNED_INT, nil);
        end;
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end;

end.

