program Project1;

uses gl, GLext, SysUtils, classes, wrappers, utils, sphere;

var
	lastTime: TDateTime = 0;
  fps, frameCnt, i, instances: integer;
begin
  instances := 1;
  WriteLn('Initializing GLFW...');
  with TGlfwWindow.Create do try
    TGlVao.Create();
    TGlBuffer.Create(GL_ARRAY_BUFFER, @SphereVertices, sizeof(SphereVertices));
    TGlBuffer.Create(GL_ELEMENT_ARRAY_BUFFER, @SphereIndices, sizeof(SphereIndices));
    TGlProgram.Create('shader');
    WriteLn('Done');
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, nil);
    repeat
      if Now - lastTime > 1/86400 then begin
        fps := Round(frameCnt * (Now - lastTime) * 86400);
        lastTime := Now;
        frameCnt := 0;
        if fps > 60 then
        	Inc(instances);
      end;
      Inc(frameCnt);
      glClear(GL_COLOR_BUFFER_BIT);
      //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      for i := 1 to 1000 do begin
        glDrawElementsInstanced(GL_TRIANGLES, High(SphereIndices), GL_UNSIGNED_INT, nil, instances);
        //glDrawArrays(GL_TRIANGLES, 0, 3*IndexSize);
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
  end;
end.

