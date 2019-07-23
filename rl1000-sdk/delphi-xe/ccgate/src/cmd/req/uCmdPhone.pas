unit uCmdPhone;

interface

uses
  Classes, uCmdBoolean, uCallManager;

type
//  {
//    cmd: "dialup",
//    data:{
//      value: true
//    }
//  }

  TCmdDoHook = class(TCmdBooleanData)
  private
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

  TCmdDoPhone = class(TCmdBooleanData)
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

  TRefuseCallIn = class(TCmdBooleanData)
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

implementation

uses uCmdComm, uResultDTO, uCmdResponse, SysUtils, uJsonSUtils, System.JSON;

{ TCmdDialup }

class function TCmdDoHook.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TCmdBooleanData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdBooleanData>>(Text);
  try
    try
      cm.doHook(u.request.param.value);
      Result := TCmdResponse.successJson(u.cmd);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    u.Free;
  end;
end;

{ TCmdHookup }

class function TCmdDoPhone.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TCmdBooleanData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdBooleanData>>(Text);
  try
    try
      cm.doPhone(u.request.param.value);
      Result := TCmdResponse.successJson(u.cmd, '');
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    u.Free;
  end;
end;

{ TRefuseCallIn }

class function TRefuseCallIn.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TCmdReqParamData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdReqParamData>>(Text);
  try
    try
      cm.refuseCallIn();
      Result := TCmdResponse.successJson(u.cmd, u.request);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    u.Free;
  end;
end;

end.

