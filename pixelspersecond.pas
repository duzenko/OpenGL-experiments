unit PixelsPerSecond;
interface uses
  Classes, SysUtils, gl,
  wrappers;

procedure TestPixelsPerSecond;

implementation

var
  instances: Integer = 60;

procedure FpsChanged();

  procedure WriteInfo(Full: Boolean = true);
  var
    Pixels: Int64;
  begin
    Pixels := 1;
    Pixels *= TGlfwWindow.Active.Width * TGlfwWindow.Active.Height;
    Pixels *= instances * TGlfwWindow.Active.FPS;
    Write(#13, Pixels div 1000000, ' MPix/sec. ');
    if Full then
      WriteLn('New load factor: ', instances, '. ');
  end;

begin
  if TGlfwWindow.Active.FPS > 60 then begin
    Inc(instances);
    WriteInfo;
    Exit;
  end;
  if (TGlfwWindow.Active.FPS < 30) and (instances > 1) then begin
    Dec(instances);
    WriteInfo;
    Exit;
  end;
  WriteInfo(false);
end;

procedure TestPixelsPerSecond;
var
  i, j: integer;
  Textures: TList;
begin
  Textures := TList.Create;
  with TGlfwWindow.Create(2.1), TGlProgram.Create('pixels') do try
    OnFpsChanged := @FpsChanged;
    repeat
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_SRC_ALPHA);
      glClear(GL_COLOR_BUFFER_BIT);
      for i := 1 to 1 do begin
        for j := 0 to instances - 1 do begin;
          if j >= Textures.Count then
            Textures.Add( TGlTexture.Create );
          TGlTexture(Textures[j]).Bind;
          Uniform('instanceID', j);
          glRectf(-1, -1, 1, 1);
        end;
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
    Textures.Free;
  end;
end;

end.

