unit TrianglesPerSecond;
interface uses
  Classes, SysUtils, gl, GLext,
  wrappers, sphere;

procedure TestTrianglesPerSecond;

implementation

var
	lastTime: TDateTime = 0;
  instances: Integer = 1;

procedure RunTest10;
var
  i, j, k: integer;
  color: array[0..2] of Single;
begin
  with TGlfwWindow.Create(1.0) do try
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
        for j := 0 to instances-1 do begin
          glLoadIdentity;
          glScalef(0.03, 0.03, 0.03);
          glTranslatef((j mod 10 - 9)*3, j div 10 * 3, 0);
          for k := 0 to 2 do
	      	color[k] := sin(j * (3+k)) * 0.3 + 0.7;
          glBegin(GL_TRIANGLES);
          glColor3fv(color);
          for k := 0 to High(SphereIndices) do
	      	glVertex3fv(@SphereVertices[SphereIndices[k]]);
          glEnd;
	  	end;
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end;

procedure RunTest11;
var
  i, j, k: integer;
  color: array[0..2] of Single;
begin
  instances := 5;
  with TGlfwWindow.Create(1.1) do try
    glInterleavedArrays(GL_V3F, 0, @SphereVertices);
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
        for j := 0 to instances-1 do begin
          glLoadIdentity;
          glScalef(0.03, 0.03, 0.03);
          glTranslatef((j mod 10 - 9)*3, j div 10 * 3, 0);
          for k := 0 to 2 do
	          color[k] := sin(j * (3+k)) * 0.3 + 0.7;
          glColor3fv(color);
        	glDrawElements(GL_TRIANGLES, Length(SphereIndices), GL_UNSIGNED_INT, @SphereIndices);
	      end;
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end;

procedure RunTest12;
var
  i, j, k: integer;
  color: array[0..2] of Single;
begin
  instances := 6;
  with TGlfwWindow.Create(1.2) do try
    glGetIntegerv(GL_MAX_ELEMENTS_VERTICES, @i);
    WriteLn('GL_MAX_ELEMENTS_VERTICES: ', i);
    glGetIntegerv(GL_MAX_ELEMENTS_INDICES, @i);
    WriteLn('GL_MAX_ELEMENTS_INDICES: ', i);
    glInterleavedArrays(GL_V3F, 0, @SphereVertices);
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
        for j := 0 to instances-1 do begin
          glLoadIdentity;
          glScalef(0.03, 0.03, 0.03);
          glTranslatef((j mod 10 - 9)*3, j div 10 * 3, 0);
          for k := 0 to 2 do
	          color[k] := sin(j * (3+k)) * 0.3 + 0.7;
          glColor3fv(color);
        	glDrawRangeElements(GL_TRIANGLES, 0, Length(SphereVertices), Length(SphereIndices), GL_UNSIGNED_INT, @SphereIndices);
	      end;
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end;

procedure RunTest15;
var
  i, j, k: integer;
  color: array[0..2] of Single;
begin
  instances := 20;
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

procedure RunTest31;
var
  i: integer;
begin
  instances := 20;
  with TGlfwWindow.Create(3.1) do try
    TGlVao.Create();
    TGlBuffer.Create(GL_ARRAY_BUFFER, @SphereVertices, sizeof(SphereVertices));
    TGlBuffer.Create(GL_ELEMENT_ARRAY_BUFFER, @SphereIndices, sizeof(SphereIndices));
    TGlProgram.Create('triangles');
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

procedure TestTrianglesPerSecond;
begin
	case 31 of
  10: RunTest10;
  11: RunTest11;
  12: RunTest12;
  15: RunTest15;
  31: RunTest31;
  end;
end;

end.

