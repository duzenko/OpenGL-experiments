unit wrappers;

interface

uses
  gl, GLext, glfw336, Classes, SysUtils;

type

  { TGlBuffer }

  TGlBuffer = class
    Ftarget: GLenum;
    Fhandle: GLuint;
    constructor Create(target: Integer; p: pointer; size: Integer);
    destructor Destroy; override;
  end;

  { TGlfwWindow }

  TGlfwWindow = class
  private
    Fhandle: pGLFWwindow;
    function GetShouldClose: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ProcessMessages;
    property ShouldClose: Boolean read GetShouldClose;
  end;

implementation

procedure glErrorCheck; begin end;

function LoadRawByteString(const s: String): String;
begin
  with TStringList.Create do try
    LoadFromFile(s);
    Result := Text;
  finally
    Free;
  end;
end;

function CreateShader(const AShaderPath: String; const AShaderType: GLenum): GLuint;
var
  Source: RawByteString;
  SourcePtr: MarshaledAString;
  Status, LogLength: GLint;
  Log: TBytes;
  Msg: String;
begin
  Result := glCreateShader(AShaderType);
  Assert(Result <> 0);
  glErrorCheck;

  Source := LoadRawByteString(AShaderPath);
  SourcePtr := MarshaledAString(Source);
  glShaderSource(Result, 1, @SourcePtr, nil);
  glErrorCheck;

  glCompileShader(Result);
  glErrorCheck;

  Status := GL_FALSE;
  glGetShaderiv(Result, GL_COMPILE_STATUS, @Status);
  if (Status <> GL_TRUE) then
  begin
    glGetShaderiv(Result, GL_INFO_LOG_LENGTH, @LogLength);
    if (LogLength > 0) then
    begin
      Log := nil;
      SetLength(Log, LogLength);
      glGetShaderInfoLog(Result, LogLength, @LogLength, @Log[0]);
      Msg := TEncoding.ANSI.GetAnsiString(Log);
      raise Exception.Create(Msg);
    end;
  end;
end;

procedure keyFunc(p: pGLFWWindow; i2, i3, i4, i5: longint); cdecl;
begin
  if(i2=256) then
    glfwSetWindowShouldClose(p, 1);
end;

{ TGlfwWindow }

function TGlfwWindow.GetShouldClose: Boolean;
begin
  result := glfwWindowShouldClose(Fhandle) <> 0;
end;

constructor TGlfwWindow.Create;
begin
  glfwInit;
  Fhandle := glfwCreateWindow(1280, 800, '', nil, nil);
  glfwMakeContextCurrent( Fhandle );
  Load_GL_version_1_5;
  glfwSwapInterval(0);
  glfwSetKeyCallback(Fhandle, @keyFunc);
end;

destructor TGlfwWindow.Destroy;
begin
  glfwTerminate;
  inherited Destroy;
end;

procedure TGlfwWindow.ProcessMessages;
begin
  glfwSwapBuffers(Fhandle);
  glfwPollEvents;
end;

{ TGlBuffer }

constructor TGlBuffer.Create(target: Integer; p: pointer; size: Integer);
begin
  Ftarget := target;
  glGenBuffers(1, @Fhandle);
  glBindBuffer(Ftarget, Fhandle);
  glBufferData(Ftarget, size, p, GL_STATIC_DRAW);
end;

destructor TGlBuffer.Destroy;
begin
  glDeleteBuffers(1, @Fhandle);
  inherited Destroy;
end;

end.

