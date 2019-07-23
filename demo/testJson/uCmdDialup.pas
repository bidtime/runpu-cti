unit uCmdDialup;

interface

uses
  Classes;

type
  TCmdReqDialupParam = class
  private
  protected
    phoneNo: string;
  public
    class function process(const Text: String): string; static;
  end;

implementation

uses uCmdComm, uCmdResponse, uJsonSUtils, SysUtils;

{ TCmdReqDialupParam }

class function TCmdReqDialupParam.process(const Text: String): string;
var u: TCmdRequest<TCmdReqDialupParam>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdReqDialupParam>>(Text);
  try
    try
      //cm.dialup(u.request.param.phoneNo);
      Result := TCmdResponse.successUUIDJson<TCmdReqDialupParam>(u);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson<TCmdReqDialupParam>(u, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

{class function TCmdReqDialupParam.Deserialize(const Text: String;
  const ev: TGetObjectFuncEvent): TObject;
var
  u: TCmdRequest<TCmdReqDialupParam>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdReqDialupParam>>(Text);
  try
    result := ev(u);
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;}

end.

