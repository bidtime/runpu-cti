unit uCmdBoolean;

interface

uses
  Classes;

type
//  {
//    cmd: "dialup",
//    data:{
//      value: true
//    }
//  }
  TCmdBooleanData = class
  private
  protected
  public
    value: boolean;
    //class function process(const Text: String): string; static;
  end;

  TCmdStringData = class
  private
  protected
  public
    value: string;
    //class function process(const Text: String): string; overload; static;
  end;

implementation

uses uCmdComm, uResultDTO, uCmdResponse, SysUtils, uJsonSUtils;

{ TCmdBooleanData }

{class function TCmdBooleanData.process(const Text: String): string;
var u: TCmdRequest<TCmdBooleanData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdBooleanData>>(Text);
  try
    try
      //Result := TCmdResponse.successJson<TCmdBooleanData>(u.cmd, u.);
      Result := '';
    except
      on e: Exception do begin
        //Result := TCmdResponse.errorJson<TCmdBooleanData>(u, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;}

{ TCmdStringData }

{class function TCmdStringData.process(const Text: String): string;
var u: TCmdRequest<TCmdStringData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdStringData>>(Text);
  try
    try
      //Result := TCmdResponse.successJson<TCmdStringData>(u);
    except
      on e: Exception do begin
        //Result := TCmdResponse.errorJson<TCmdStringData>(u, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;}

{class function TCmdStringData.process(const Text: String; const ev: TGetStrObject): string;
var u: TCmdRequest<TCmdStringData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdStringData>>(Text);
  try
    try
      if Assigned(ev) then begin
        Result := ev(u);
      end else begin
        Result := TCmdResponse.successJson<TCmdStringData>(u);
        Result := 'aaaa';
      end;
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson<TCmdStringData>(u, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;}

{class function TCmdBoolean.Deserialize(const Text: string;
  const ev: TGetObjectFuncEvent): TObject;
var u: TCmdBoolean;
begin
  u := TJsonSUtils.Deserialize<TCmdBoolean>(Text);
  try
    Result := ev(u);
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;}

end.

