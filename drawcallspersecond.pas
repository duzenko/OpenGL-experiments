unit DrawCallsPerSecond;

interface uses
  Classes, SysUtils, gl, glext,
  wrappers;

procedure TestDrawCallsPerSecond;

implementation

var
	lastTime: TDateTime = 0;
  instances: Integer = 1;

procedure RunTest;
var
  i, j, k: integer;
  color: array[0..2] of Single;
  Textures: TList;
begin
  instances := 20;
  Textures := TList.Create;
  with TGlfwWindow.Create(4.3) do try
    TGlVao.Create();
    TGlProgram.Create('shader43');
    repeat
      if Now - lastTime > 1/86400 then begin
        if lastTime > 0 then begin
          if fps > 60 then begin
          	Inc(instances);
            WriteLn(instances);
          end;
          if (fps < 30) and (instances > 1) then begin
          	Dec(instances);
            WriteLn(instances);
          end;
        end;
        lastTime := Now;
      end;
      glClear(GL_COLOR_BUFFER_BIT);
      for i := 1 to 1000 do begin
        for j := 0 to instances - 1 do begin;
          if j >= Textures.Count then
            Textures.Add( TGlTexture.Create );
          TGlTexture(Textures[j]).Bind;
          glUniform1i(0, j);
          glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        end;
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
    Textures.Free;
  end;
end;

procedure TestDrawCallsPerSecond;
begin
	RunTest;
end;

end.

