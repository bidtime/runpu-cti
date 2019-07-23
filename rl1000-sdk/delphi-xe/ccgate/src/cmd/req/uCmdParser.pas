unit uCmdParser;

interface

uses
  Classes, Messages, uShowMsgBase, uCallManager, System.Json;

type
  TCmdParser = class(TShowMsgBase)
  private
  public
    { Public declarations }
    function parser(const Text: string; const cm: TCallManager): string;
  end;

implementation

uses SysUtils, REST.JSON, uFormatMsg, uCmdType, uCmdComm, uCmdDialup,
  uCmdBoolean, uCmdException, uCmdPhone, uCmdCookie, uCmdResponse, uResultDTO,
  uLog4me;

{ TCmdParser }

function TCmdParser.parser(const Text: string; const cm: TCallManager): string;

    function resposeDTO(const cmd: string; const dto: TObject;
      const cmdReq: TJsonValue): string;
    var jsobject: TJsonObject;
    begin
      jsobject := TJsonObject.Create;;
      try
        jsobject.AddPair('cmd', cmd);
        jsobject.AddPair('request', cmdReq);
        jsobject.AddPair('response', TJson.ObjectToJsonObject(dto));
        Result := jsobject.ToString;
      finally
        jsobject.RemovePair('request');
        jsobject.Free;
      end;
    end;

  function errorDTO(const cmd: string; const msg: string; const jsonReq: TJsonValue): string;
  var dto: TResultDTO<TResultData>;
  begin
    dto := TResultDTO<TResultData>.error(msg);
    try
      Result := resposeDTO(cmd, dto, jsonReq);
    finally
      dto.Free;
    end;
  end;

  function doCmdReq(const cmd: string; const jsonReq: TJsonValue): string;
  begin
    try
      if cmd.Equals(CMD_START_DIAL) then begin
        Result := TCmdReqStartDialup.process(Text, cm);
      end else if cmd.Equals(CMD_STOP_DIAL) then begin
        Result := TCmdReqStopDialup.process(Text, cm);
      end else if cmd.Equals(CMD_RESET_CALL) then begin
        Result := TCmdReqResetCallLog.process(Text, cm);
      end else if cmd.Equals(CMD_CONFIRM_DIAL) then begin
        Result := TConfirmDialParam.process(Text, cm);
      end else if cmd.Equals(CMD_CONFIRM_CALL_IN) then begin
        Result := TConfirmCallInParam.process(Text, cm);
      end else if cmd.Equals(CMD_DO_HOOK) then begin
        Result := TCmdDoHook.process(Text, cm);
      end else if cmd.Equals(CMD_DO_PHONE) then begin
        Result := TCmdDoPhone.process(Text, cm);
      end else if cmd.Equals(CMD_REFUSE_CALL_IN) then begin
        Result := TRefuseCallIn.process(Text, cm);
      end else if cmd.Equals(CMD_ADD_COOKIE) then begin
        Result := TAddCookie.process(Text);
      end else begin
        Result := errorDTO(cmd, '不被接受的命令参数', jsonReq);
      end;
    except
      on e: Exception do begin
        ShowMsg('error: ' + '(' + e.ClassName + '), ' + e.Message);
        //raise TCmdException.create(errorDTO(cmd, e, jsonReq));
        Result := errorDTO(cmd, e.Message, jsonReq);
      end;
    end;
  end;

  function doCmd(const Root: TJSONObject): string;
  var cmd: string;
    jsReq: TJsonValue;
  begin
    if ( Root.TryGetValue('cmd', cmd) ) then begin
      self.ShowMsg('cmd: -> ' + cmd);
      Root.TryGetValue('request', jsReq);
      Result := doCmdReq(cmd, jsReq);
    end else begin
      Result := 'echo json -> ' + Text;
    end;
  end;

var Root: TJSONObject;
begin
  Root := nil;
  try
    try
      Root := TJSONObject.ParseJSONValue(Text) as TJSONObject;
    except
      on e: exception do begin
        Result := 'echo text -> ' + Text;
        log4error(Result);
      end;
    end;
    Result := doCmd(Root);
  finally
    if Assigned(Root) then begin
      Root.Free;
    end;
  end;
end;

end.

