unit uCharComm;

interface

uses
  brisdklib;

  function toStr(a: Array of BRICHAR8): string;
//  function toStrH(a: Array of BRICHAR8; const c: BRICHAR8=#10): string; overload;
//  function toStrH(const a: string; const c: char=#13): string; overload;

implementation

uses SysUtils, AnsiStrings;

{ TProcessPhoneMsg }

function toStr(a: Array of BRICHAR8): string;
begin
  Result := AnsiStrings.StrPas(a);
end;
{var i: integer;
  c: BRICHAR8;
begin
  for I := 0 to Length(a) do begin
    c := a[i];
    if c=#0 then begin
      break;
    end else begin
      Result := Result + c;
    end;
  end;
end;}

//function toStrH(a: Array of BRICHAR8; const c: BRICHAR8): string;
//var i: integer;
//  t: BRICHAR8;
//begin
//  Result := '';
//  for I := 0 to Length(a) do begin
//    t := a[i];
//    if t=c then begin
//      break;
//    end else begin
//      Result := Result + t;
//    end;
//  end;
//end;
//
//function toStrH(const a: string; const c: char=#13): string;
//var i: integer;
//  t: char;
//begin
//  Result := '';
//  for I := 1 to Length(a) do begin
//    t := a[i];
//    if t=c then begin
//      break;
//    end else begin
//      Result := Result + t;
//    end;
//  end;
//end;

{procedure TProcessPhoneMsg.MyMsgProc(var Msg: TMessage);
  function getRec(const src: TBriEvent_Data): TBriEvent_Data;
  var dst: TBriEvent_Data;
  begin
    //CopyMemory(@dst, @src, sizeof(src));
    //Move(@src, @dst, sizeof(src));
    dst.uVersion := src.uVersion;
    dst.uReserv := src.uReserv;
    dst.uChannelID := src.uChannelID;
    dst.lEventType := src.lEventType;
    dst.lEventHandle := src.lEventHandle;
    dst.lResult := src.lResult;
    dst.lParam := src.lParam;
    CopyMemory(@dst.szData, @src.szData, sizeof(src.szData));
    CopyMemory(@dst.szDataEx, @src.szDataEx, sizeof(src.szDataEx));
    Result := dst;
  end;
var
  pEvent: PTBriEvent_Data;
  //dst: TBriEvent_Data;
begin
  //self.FMRESSync.BeginWrite();
  try
    pEvent := PTBriEvent_Data(Msg.LParam);
    //QNV_Event(uChannelID, QNV_EVENT_POP, 0, NULL, @e, 0);  //演示主动获取事件函数方式,侦听显示消息
    //dst := getRec(pEvent^);
    ProcessMsgProc(pEvent^);
  finally
    //self.FMRESSync.EndWrite();
  end;
end;}

end.


