unit wrappers;

interface uses
  SysUtils, Classes, contnrs, gl, GLext, glfw336,
  utils;

type

  { TGlObject }

  TGlObject = class
    Fhandle: GLuint;
    constructor Create;
    destructor Destroy; override;
    procedure Bind; virtual; abstract;
  end;

  { TGlVao }

  { TGlTexture }

  TGlTexture = class(TGlObject)
    constructor Create();
    destructor Destroy; override;
    procedure Bind; override;
  end;

  { TGlVao }

  TGlVao = class(TGlObject)
    constructor Create();
    destructor Destroy; override;
  end;

  { TGlBuffer }

  TGlBuffer = class(TGlObject)
    Ftarget: GLenum;
    constructor Create(target: Integer; p: pointer; size: Integer);
    destructor Destroy; override;
  end;

  { TGlProgram }

  TGlProgram = class(TGlObject)
  public
    constructor Create(const FileName: String);
    destructor Destroy; override;
  end;

  { TGlfwWindow }

  TGlfwWindow = class
  private
    Ffps: Integer;
    Fhandle: pGLFWwindow;
    FObjects: TObjectList;
    FActive: TGlfwWindow; static;
    function GetShouldClose: Boolean;
  public
    constructor Create(glVersion: Currency; Core: Boolean = false);
    destructor Destroy; override;
    procedure ProcessMessages;
    property ShouldClose: Boolean read GetShouldClose;
    property FPS: Integer read Ffps;
    class property Active: TGlfwWindow read FActive;
  end;

implementation

procedure keyFunc(p: pGLFWWindow; i2, i3, i4, i5: longint); cdecl;
begin
  if(i2=256) then
    glfwSetWindowShouldClose(p, 1);
end;

{ TGlTexture }

constructor TGlTexture.Create;
var
  i, j: Integer;
  data: array[0..15, 0..15] of Byte;
begin
  glGenTextures(1, @Fhandle);
  glBindTexture(GL_TEXTURE_2D, Fhandle);
  for i := 0 to 15 do begin
    for j := 0 to 15 do begin
      data[i][j] := 255 * byte( (i+Fhandle) and 8 = (j+GetTickCount+Integer(Self) shr 4) and 8 );
    end;
  end;
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, 16, 16, 0, GL_RED, GL_UNSIGNED_BYTE, @data);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
end;

destructor TGlTexture.Destroy;
begin
  glDeleteTextures(1, @Fhandle);
  inherited Destroy;
end;

procedure TGlTexture.Bind;
begin
  glBindTexture(GL_TEXTURE_2D, Fhandle);
end;

{ TGlVao }

constructor TGlVao.Create();
begin
  glGenVertexArrays(1, @Fhandle);
  glBindVertexArray(Fhandle);
end;

destructor TGlVao.Destroy;
begin
  glDeleteVertexArrays(1, @Fhandle);
  inherited Destroy;
end;

{ TGlObject }

constructor TGlObject.Create;
begin
  glErrorCheck;
  TGlfwWindow.Active.FObjects.Add(Self);
end;

destructor TGlObject.Destroy;
begin
  TGlfwWindow.Active.FObjects.Remove(Self);
  inherited Destroy;
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
  VertexShader := CreateShader('glsl\' + FileName+'.vs', GL_VERTEX_SHADER);
  try
    FragmentShader := CreateShader('glsl\' + FileName+'.fs', GL_FRAGMENT_SHADER);
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

constructor TGlfwWindow.Create(glVersion: Currency; Core: Boolean);
begin
  if Assigned(Active) then
     Abort;
  FActive := Self;
  glfwInit;
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, Trunc(glVersion));
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, Round(Frac(glVersion)*10));
  if Core then begin
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  end;
  WriteLn('Creating window...');
  Fhandle := glfwCreateWindow(1280, 800, '', nil, nil);
  if Fhandle = nil then
     raise Exception.Create('GLFW failed to create window');
  WriteLn('Loading GL functions...');
  glfwMakeContextCurrent( Fhandle );
  repeat until glGetError() = GL_NO_ERROR;
  glfwSetWindowTitle(Fhandle, PChar(String(glGetString(GL_RENDERER)) + ' - ' + String(glGetString(GL_VERSION))));
  if glVersion <= 1.2 then
	  Load_GL_version_1_2()
  else if glVersion <= 1.5 then
	  Load_GL_version_1_5()
  else if glVersion = 3.1 then
	  Load_GL_version_3_1_CORE()
  else
	  Load_GL_version_4_3_CORE();
  FObjects := TObjectList.Create();
  glfwSwapInterval(0);
  glfwSetKeyCallback(Fhandle, @keyFunc);
  WriteLn('Done');
end;

destructor TGlfwWindow.Destroy;
begin
  FObjects.Free;
  glfwTerminate;
  FActive := nil;
  inherited Destroy;
end;

procedure TGlfwWindow.ProcessMessages;
const
	lastTime: TDateTime = 0;
  frameCnt: Integer = 0;
begin
  glfwSwapBuffers(Fhandle);
  glfwPollEvents;
  if Now - lastTime > 1/86400 then begin
    Ffps := Round(frameCnt * (Now - lastTime) * 86400);
    lastTime := Now;
    frameCnt := 0;
  end;
  Inc(frameCnt);
end;

{ TGlBuffer }

constructor TGlBuffer.Create(target: Integer; p: pointer; size: Integer);
begin
  inherited Create;
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

