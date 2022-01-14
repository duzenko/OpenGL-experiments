unit sphere;

{$mode ObjFPC}{$H+}
{$modeSwitch advancedRecords}

interface

uses
  Classes, SysUtils;

type

  { TVertexAttributes }

	TVertexAttributes = record
 		x, y, z: Single;
		procedure Reset(Ax, Ay, Az: Single);
		procedure Normalize();
  end;

const
  SphereSubdivision1 = 50; // so that we have exactly 10000 triangles in total
  SphereSubdivision2 = 100;
var
  SphereVertices: array[0..(SphereSubdivision1+1)*(SphereSubdivision2+1)-1] of TVertexAttributes;
  SphereIndices: array[0..6*SphereSubdivision1*SphereSubdivision2-1] of Integer;

implementation

procedure CalculateSphereVertices;
var
  i, j, index, vindex: integer;
	xz: Single;
  va: TVertexAttributes;
begin
  for i := 0 to SphereSubdivision1-1 do begin
    index := 6*SphereSubdivision2*i;
    vindex := (SphereSubdivision2+1)*i;
  	for j := 0 to SphereSubdivision2-1 do begin
      SphereIndices[index] := vindex;
      SphereIndices[index+1] := vindex+1;
      SphereIndices[index+2] := vindex+SphereSubdivision2+1;
      SphereIndices[index+3] := vindex+SphereSubdivision2+1;
      SphereIndices[index+4] := vindex+1;
      SphereIndices[index+5] := vindex+SphereSubdivision2+2;
      Inc(index, 6);
      Inc(vindex);
    end;
  end;
  for i := 0 to SphereSubdivision1 do begin
    vindex := (SphereSubdivision2+1)*i;
    va.y := 0.9*cos(i*Pi/SphereSubdivision1);
    xz := Sin(i*Pi/SphereSubdivision1);
  	for j := 0 to SphereSubdivision2 do begin
      va.x := xz*Sin(j*2*Pi/SphereSubdivision2);
      va.z := xz*Cos(j*2*Pi/SphereSubdivision2);
      SphereVertices[vindex] := va;
      Inc(vindex);
    end;
	end;
end;

{ TVertexAttributes }

procedure TVertexAttributes.Reset(Ax, Ay, Az: Single);
begin
  x := Ax;
  y := Ay;
  z := Az;
end;

procedure TVertexAttributes.Normalize;
var
  invlen: Single;
begin
  invlen := 1/Sqrt(x*x+y*y+z*z);
  x := x * invlen;
  y := y * invlen;
  z := z * invlen;
end;

initialization
	WriteLn('Initializing data...');
	CalculateSphereVertices;

end.

