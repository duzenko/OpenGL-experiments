unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, gl, GLext;

procedure glErrorCheck;
function CreateShader(const AShaderPath: String; const AShaderType: GLenum): GLuint;

implementation

procedure glErrorCheck;
var
  err: TGLenum;
begin
  err := glGetError();
  if err <> GL_NO_ERROR then
     WriteLn('GL error ', err);
end;

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

end.

