unit uCmdDialup;

interface

uses
  Classes, uCallManager;

type
  TCmdReqStartDialup = class
  private
  protected
    phoneNo: string;
    prefix: string;
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

  TCmdReqStopDialup = class
  private
  protected
    phoneNo: string;
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

  TCmdReqResetCallLog = class
  private
  protected
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

  TConfirmCallInParam = class
  private
  protected
    callUUID: string;
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

  TConfirmDialParam = class
  private
  protected
    callUUID: string;
  public
    class function process(const Text: String; const cm: TCallManager): string; static;
  end;

implementation

uses uCmdComm, uCmdResponse, uJsonSUtils, SysUtils, uResultDTO;

{ TCmdReqStartDialup }

class function TCmdReqStartDialup.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TCmdReqStartDialup>;
 data: TResultStringU;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdReqStartDialup>>(Text);
  try
    try
      data := TResultStringU.create;
      cm.startDialup(u.request.param.prefix, u.request.param.phoneNo, data.value);
      Result := TCmdResponse.dataToJson(u.cmd, u.request, data);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

class function TCmdReqStopDialup.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TCmdReqStopDialup>;
 data: TResultStringU;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdReqStopDialup>>(Text);
  try
    try
      data := TResultStringU.create;
      cm.stopDialup();
      Result := TCmdResponse.dataToJson(u.cmd, u.request, data);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

class function TCmdReqResetCallLog.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TCmdReqResetCallLog>;
 data: TResultStringU;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdReqResetCallLog>>(Text);
  try
    try
      data := TResultStringU.create;
      cm.resetCall();
      Result := TCmdResponse.dataToJson(u.cmd, u.request, data);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

class function TConfirmCallInParam.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TConfirmCallInParam>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TConfirmCallInParam>>(Text);
  try
    try
      cm.confirmCallIn(u.request.param.callUUID);
      Result := TCmdResponse.successJson(u.cmd, u.request);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

class function TConfirmDialParam.process(const Text: String;
  const cm: TCallManager): string;
var u: TCmdRequest<TConfirmDialParam>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TConfirmDialParam>>(Text);
  try
    try
      cm.confirmDial(u.request.param.callUUID);
      Result := TCmdResponse.successJson(u.cmd, u.request);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
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

