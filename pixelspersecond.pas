unit PixelsPerSecond;
interface uses
  Classes, SysUtils, gl,
  wrappers;

procedure TestPixelsPerSecond;

implementation

var
  instances: Integer = 60;
  textureCount: Integer = 1;

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

procedure KeyPressed(Key: LongInt);

  procedure WriteInfo(Full: Boolean = true);
  begin
    WriteLn('Texture count: ', textureCount, '. ');
  end;

begin
  WriteLn('Key pressed: ', Key);
  if (Key = 334) and (textureCount < 8) then begin
    Inc(textureCount);
    WriteInfo();
  end;
  if (Key = 333) and (textureCount > 0) then begin
    Dec(textureCount);
    WriteInfo();
  end;
end;

procedure TestPixelsPerSecond;
var
  i, j: integer;
  Textures: TList;
begin
  Textures := TList.Create;
  with TGlfwWindow.Create(2.1), TGlProgram.Create('pixels') do try
    OnFpsChanged := @FpsChanged;
    OnKeyPressed := @KeyPressed;
    repeat
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_SRC_ALPHA);
      glClear(GL_COLOR_BUFFER_BIT);
      Uniform('textureCount', textureCount);
      while textureCount >= Textures.Count do
        Textures.Add( TGlTexture.Create );
      for i := 0 to textureCount - 1 do
        TGlTexture(Textures[i]).Bind(i);
      for j := 0 to instances - 1 do begin;
        Uniform('instanceID', j);
        glRectf(-1, -1, 1, 1);
      end;
      ProcessMessages;
    until ShouldClose;
  finally
    Free;
    Textures.Free;
  end;
end;

end.

