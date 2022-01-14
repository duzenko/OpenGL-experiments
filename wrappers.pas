unit wrappers;

interface

uses
  SysUtils, Classes, contnrs, gl, GLext, glfw336,
  utils;

type

  { TGlObject }

  TGlObject = class
    Fhandle: GLuint;
    constructor Create;
    destructor Destroy; override;
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
    Fhandle: pGLFWwindow;
    FObjects: TObjectList;
    FActive: TGlfwWindow; static;
    function GetShouldClose: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ProcessMessages;
    property ShouldClose: Boolean read GetShouldClose;
    class property Active: TGlfwWindow read FActive;
  end;

implementation

procedure keyFunc(p: pGLFWWindow; i2, i3, i4, i5: longint); cdecl;
begin
  if(i2=256) then
    glfwSetWindowShouldClose(p, 1);
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
  if Assigned(Active) then
     Abort;
  FActive := Self;
  glfwInit;
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  Fhandle := glfwCreateWindow(1280, 800, '', nil, nil);
  if Fhandle = nil then
     raise Exception.Create('GLFW failed to create window');
  glfwMakeContextCurrent( Fhandle );
  repeat until glGetError() = GL_NO_ERROR;
  glfwSetWindowTitle(Fhandle, PChar(String(glGetString(GL_RENDERER)) + ' - ' + String(glGetString(GL_VERSION))));
  Load_GL_version_3_2_CORE;
  FObjects := TObjectList.Create();
  glfwSwapInterval(0);
  glfwSetKeyCallback(Fhandle, @keyFunc);
end;

destructor TGlfwWindow.Destroy;
begin
  FObjects.Free;
  glfwTerminate;
  FActive := nil;
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

