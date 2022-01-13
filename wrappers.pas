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

  { TGlProgram }

  TGlProgram = class
    Fhandle: GLuint;
    constructor Create(const FileName: String);
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

{ TGlProgram }

constructor TGlProgram.Create(const FileName: String);
var
  Status, LogLength: GLint;
  FProgram, VertexShader, FragmentShader: GLuint;
  Log: TBytes;
  Msg: String;
begin
  FragmentShader := 0;
  VertexShader := CreateShader(FileName+'.vs', GL_VERTEX_SHADER);
  try
    FragmentShader := CreateShader(FileName+'.fs', GL_FRAGMENT_SHADER);
    FProgram := glCreateProgram();

    glAttachShader(FProgram, VertexShader);
    glErrorCheck;

    glAttachShader(FProgram, FragmentShader);
    glErrorCheck;

    glLinkProgram(FProgram);
    glGetProgramiv(FProgram, GL_LINK_STATUS, @Status);

    if (Status <> GL_TRUE) then
    begin
      glGetProgramiv(FProgram, GL_INFO_LOG_LENGTH, @LogLength);
      if (LogLength > 0) then begin
        Log := nil;
       SetLength(Log, LogLength);
       glGetProgramInfoLog(FProgram, LogLength, @LogLength, @Log[0]);
       Msg := TEncoding.ANSI.GetAnsiString(Log);
       raise Exception.Create(Msg);
      end;
    end;
    glErrorCheck;

  finally
    if (FragmentShader <> 0) then
     glDeleteShader(FragmentShader);

    if (VertexShader <> 0) then
     glDeleteShader(VertexShader);
  end;
  Fhandle:= FProgram;
  glUseProgram(Fhandle);
end;

destructor TGlProgram.Destroy;
begin
  inherited Destroy;
end;

{ TGlfwWindow }

function TGlfwWindow.GetShouldClose: Boolean;
begin
  result := glfwWindowShouldClose(Fhandle) <> 0;
end;

constructor TGlfwWindow.Create;
begin
  glfwInit;
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  Fhandle := glfwCreateWindow(1280, 800, '', nil, nil);
  if Fhandle = nil then
     raise Exception.Create('GLFW failed to create window');
  glfwMakeContextCurrent( Fhandle );

  glfwSetWindowTitle(Fhandle, PChar(String(glGetString(GL_RENDERER)) + ' - ' + String(glGetString(GL_VERSION))));
  Load_GL_version_3_3;
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

