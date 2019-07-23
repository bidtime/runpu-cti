unit uCharComm;

interface

uses
  brisdklib;

  function toStr(a: Array of BRICHAR8): string;
  function toStrH(a: Array of BRICHAR8; const c: BRICHAR8=#10): string; overload;
  function toStrH(const a: string; const c: char=#13): string; overload;

implementation

{ TProcessPhoneMsg }

function toStr(a: Array of BRICHAR8): string;
var i: integer;
  c: BRICHAR8;
begin
  Result := '';
  for I := 0 to Length(a) do begin
    c := a[i];
    if c=#0 then begin
      break;
    end else begin
      Result := Result + c;
    end;
  end;
end;

function toStrH(a: Array of BRICHAR8; const c: BRICHAR8): string;
var i: integer;
  t: BRICHAR8;
begin
  Result := '';
  for I := 0 to Length(a) do begin
    t := a[i];
    if t=c then begin
      break;
    end else begin
      Result := Result + t;
    end;
  end;
end;

function toStrH(const a: string; const c: char=#13): string;
var i: integer;
  t: char;
begin
  Result := '';
  for I := 1 to Length(a) do begin
    t := a[i];
    if t=c then begin
      break;
    end else begin
      Result := Result + t;
    end;
  end;
end;

end.


