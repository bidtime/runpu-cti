unit uChannelCmd;

interface

uses
  brisdklib;

type
  TChannelCmd = class
  private
    class procedure tryGetError(const ret: longint; const msgName: string); static;
  public
    { Public declarations }
    class function fmtEvent(const evData: TBriEvent_Data; const full: boolean=true): string; static;
  end;

  TGeneralCmd = class
  private
  public
    { Public declarations }
    class function General(chnId: BRIINT16; uGeneralType:longint;
      nValue:longint; pValue:BRIPCHAR8):longint; overload;
    class function General(chnId: BRIINT16; uGeneralType:longint):longint; overload;
    class function tryGeneral(chnId: BRIINT16; uGeneralType:longint; const msgName: string):longint; overload;
    class function tryGeneral(chnId: BRIINT16; uGeneralType:longint;
      nValue:longint; pValue:BRIPCHAR8; const msgName: string):longint; overload;
    class function isRefUseing(chnId: BRIINT16): longint; static;
    class function getCallId(chnId: BRIINT16): string; static;
    class function getDialCodeEx(chnId: BRIINT16): string; static;
    class function lineHook(chnId: BRIINT16): longint; static;
    class function lineFree(chnId: BRIINT16): longint; static;
    class procedure tryRefuseCallIn(chnId: BRIINT16); static;
  end;

  TDevCtrlCmd = class
  private
  public
    { Public declarations }
    class function getDevCtrl(chnId: BRIINT16; uCtrlType: longint): longint;
    class procedure tryGetDevCtrl(chnId: BRIINT16; uCtrlType: longint;
      const msgName: string); static;
    class procedure trySetDevCtrl(chnId: BRIINT16; uCtrlType:longint; nValue:longint; const msgName: string);
    class function setDevCtrl(chnId: BRIINT16; uCtrlType:longint; nValue:longint):longint;
    class procedure hangup(chnId: BRIINT16; const dophone: boolean); static;
    class procedure hookup(chnId: BRIINT16; const dohook: boolean); static;
  end;

  TCallLogInfo = record
  public
    beginTime: longint;
    endTime: longint;
    ringBackTime: longint;
    connectedTime: longint;
    callType: integer;
    callResult: integer;
    callId: string;
  end;

  TCallLogCmd = class
  private
    class function CallLog(chnId: BRIINT16; uLogType:longint;
      pValue: BRIPCHAR8; nValue: longint): longint; overload;
    class function CallLog(chnId: BRIINT16; uLogType:longint): longint; overload;
    class function tryGetCallId(chnId: BRIINT16): string; static;
  public
    { Public declarations }
    class function resetCall(chnId: BRIINT16): longint; static;
    //
    class function getCallType(chnId: BRIINT16): longint; static;
    class function getCallResult(chnId: BRIINT16): longint; static;
    class function getCallId(chnId: BRIINT16): string; static;
    //
    class function getConnectedTime(chnId: BRIINT16): longint; static;
    class function getBeginTime(chnId: BRIINT16): longint; static;
    class function getEndTime(chnId: BRIINT16): longint; static;
    class function getRingBackTime(chnId: BRIINT16): longint; static;
    //
    class function fmtCallLog(const evData: TBriEvent_Data): string; overload; static;
    class function fmtCallLog(chanId: BRIINT16): string; overload; static;
    class function getCallLonInfo(chnId: BRIINT16): TCallLogInfo; static;
  end;

implementation

uses Windows, SysUtils, uCharComm, uEventTypeMap;

{ TChannelCmd }

procedure ShowSysLog(const S: String);
begin
  //g_ShowMsgBase.ShowMsg(S);
end;

procedure ShowMsg(chnId: BRIINT16; const S: String);
begin
  ShowSysLog('通道' + IntToStr(chnId) + ', ' + S);
end;

class function TChannelCmd.fmtEvent(const evData: TBriEvent_Data; const full: boolean): string;
  function getSimple(): string;
  const FMT_STR = '%d'
    + ',evId=%d,name=%s'
    + ',handle=%d,rst=%d,par=%d'
    + ',szData=%s,szDataEx=%s'
    + ',linehook=%d,linefree=%d'
    ;
  var chanId: BRIINT16;
  begin
    chanId := evData.uChnId;
    Result := format(FMT_STR, [evData.uChnId
      , evData.lEventType, TEventTypeMap.getEvent(evData.lEventType)
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
      , TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId)
    ]);
  end;
  function getFull(): string;
  const FMT_STR = '%d'
    + ',evId=%d,name=%s'
    + ',handle=%d,rst=%d,par=%d'
    + ',data=%s,dataEx=%s'
    + ',linehook=%d,linefree=%d'
    + ',callType=%d,callResult=%d'
    ;
  var chanId: BRIINT16;
  begin
    chanId := evData.uChnId;
    Result := format(FMT_STR, [evData.uChnId
      , evData.lEventType, TEventTypeMap.getEvent(evData.lEventType)
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
      , TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId)
      , TCallLogCmd.getCallType(chanId), TCallLogCmd.getCallResult(chanId)
    ]);
  end;
begin
  if full then begin
    Result := getFull();
  end else begin
    Result := getSimple();
  end;
end;

class procedure TChannelCmd.tryGetError(const ret: longint; const msgName: string);
begin
  if ret <= 0 then begin
    raise Exception.Create(msgName + '失败，错误码(' + IntToStr(ret) + ').');
  end;
end;

{ TGeneralCmd }

class function TGeneralCmd.General(chnId: BRIINT16; uGeneralType, nValue: longint;
  pValue: BRIPCHAR8): longint;
const FMT = 'CPC_General: channel=%d, GeneralType=%d, value=%d. Result(%d)';
begin
  Result := CPC_General(chnId, uGeneralType, nValue, pValue);
  ShowMsg(chnId, format(FMT, [chnId, uGeneralType, nValue, Result]));
end;

class function TGeneralCmd.General(chnId: BRIINT16; uGeneralType: longint): longint;
begin
  Result := General(chnId, uGeneralType, 0, '');
end;

class function TGeneralCmd.tryGeneral(chnId: BRIINT16; uGeneralType,
  nValue: longint; pValue: BRIPCHAR8; const msgName: string): longint;
begin
  Result := General(chnId, uGeneralType, nValue, pValue);
  if Result <= 0 then begin
    TChannelCmd.tryGetError(Result, msgName);
  end;
end;

class function TGeneralCmd.tryGeneral(chnId: BRIINT16; uGeneralType: longint;
  const msgName: string): longint;
begin
  Result := General(chnId, uGeneralType);
  if Result <= 0 then begin
    TChannelCmd.tryGetError(Result, msgName);
  end;
end;

class function TGeneralCmd.isRefUseing(chnId: BRIINT16): longint;
begin
  Result := General(chnId, CPC_GENERAL_ISREFUSEING);
end;

class function TGeneralCmd.getCallId(chnId: BRIINT16): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := General(chnId, CPC_GENERAL_GETCALLID, MAX_BRIEVENT_DATA, @szData);
  if ret <= 0 then begin
    raise Exception.Create('获取来电号码失败，错误码(' + IntToStr(ret) + ').');
  end;
  Result := toStr(szData);
end;

class function TGeneralCmd.getDialCodeEx(chnId: BRIINT16): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := General(chnId, CPC_GENERAL_GETTELDIALCODEEX, MAX_BRIEVENT_DATA, @szData);
  if ret <= 0 then begin
    raise Exception.Create('获取已拨号码失败，错误码(' + IntToStr(ret) + ').');
  end;
  Result := toStr(szData);
end;

class function TGeneralCmd.lineHook(chnId: BRIINT16): longint;
begin
  Result := General(chnId, CPC_GENERAL_ISLINEHOOK);
end;

class function TGeneralCmd.lineFree(chnId: BRIINT16): longint;
begin
  Result := General(chnId, CPC_GENERAL_ISLINEFREE);
end;

class procedure TGeneralCmd.tryRefuseCallIn(chnId: BRIINT16);
begin
  if TDevCtrlCmd.GetDevCtrl(chnId, CPC_CTRL_RINGTIMES) <= 0 then begin
	  raise Exception.Create('没有来电，无效的拒接');
  end else begin
    // REFUSE_ASYN, REFUSE_SYN
    tryGeneral(chnId, CPC_GENERAL_STARTREFUSE, REFUSE_SYN, NULL, '拒绝来电');
  end;
end;

{TCallLogCmd}

class function TCallLogCmd.CallLog(chnId: BRIINT16; uLogType:longint; pValue:BRIPCHAR8; nValue:longint): longint;
const FMT = 'CPC_CallLog: channel=%d, logType=%d, value=%d. Result(%d)';
begin
  Result := CPC_CallLog(chnId, uLogType, pValue, nValue);
  ShowMsg(chnId, format(FMT, [chnId, uLogType, nValue, Result]));
end;

class function TCallLogCmd.CallLog(chnId: BRIINT16; uLogType: longint): longint;
begin
  Result := CallLog(chnId, uLogType, NULL, 0);
end;

class function TCallLogCmd.getCallResult(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_CALLRESULT);
end;

class function TCallLogCmd.getCallType(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_CALLTYPE);
end;

class function TCallLogCmd.getConnectedTime(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_CONNECTEDTIME);
end;

class function TCallLogCmd.getBeginTime(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_BEGINTIME);
end;

class function TCallLogCmd.getEndTime(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_ENDTIME);
end;

class function TCallLogCmd.getRingBackTime(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_RINGBACKTIME);
end;

class function TCallLogCmd.resetCall(chnId: BRIINT16): longint;
begin
  Result := CallLog(chnId, CPC_CALLLOG_RESET);
end;

class function TCallLogCmd.getCallId(chnId: BRIINT16): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := CallLog(chnId, CPC_CALLLOG_CALLID, @szData, MAX_BRIEVENT_DATA);
  if ret > 0 then begin
    Result := toStr(szData);
  end else begin
    Result := '';
  end;
end;

class function TCallLogCmd.getCallLonInfo(chnId: BRIINT16): TCallLogInfo;
var u: TCallLogInfo;
begin
  u.beginTime := getBeginTime(chnId);
  u.endTime := getEndTime(chnId);
  u.ringBackTime := getRingBackTime(chnId);
  u.connectedTime := getConnectedTime(chnId);
  u.callType := getCallType(chnId);
  u.callResult := getCallResult(chnId);
  u.callId := getCallId(chnId);
  Result := u;
end;

class function TCallLogCmd.tryGetCallId(chnId: BRIINT16): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := CallLog(chnId, CPC_CALLLOG_CALLID, @szData, MAX_BRIEVENT_DATA);
  if ret <= 0 then begin
    raise Exception.Create('获取来电号码失败，错误码(' + IntToStr(ret) + ').');
  end;
  Result := toStr(szData);
end;

class function TCallLogCmd.fmtCallLog(const evData: TBriEvent_Data): string;
begin
  Result := TChannelCmd.fmtEvent(evData, true);
end;

class function TCallLogCmd.fmtCallLog(chanId: BRIINT16): string;
const FMT_STR = ''
  + 'linehook=%d, linefree=%d'
  + ', callType=%d, callResult=%d'
  ;
begin
  Result := format(FMT_STR, [
    TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId)
    , getCallType(chanId), getCallResult(chanId)
  ]);
end;

{ TDevCtrlCmd }

class function TDevCtrlCmd.GetDevCtrl(chnId: BRIINT16; uCtrlType: longint): longint;
const FMT = 'GetDevCtrl: channel=%d, CtrlType=%d. Result(%d)';
begin
  Result := CPC_GetDevCtrl(chnId, uCtrlType);
  ShowMsg(chnId, format(FMT, [chnId, uCtrlType, Result]));
end;

class procedure TDevCtrlCmd.tryGetDevCtrl(chnId: BRIINT16; uCtrlType: longint; const msgName: string);
var ret: longint;
begin
  ret := GetDevCtrl(chnId, uCtrlType);
  TChannelCmd.tryGetError(ret, msgName);
end;

class procedure TDevCtrlCmd.trySetDevCtrl(chnId: BRIINT16; uCtrlType:longint;
  nValue:longint; const msgName: string);
var ret: longint;
begin
  ret := SetDevCtrl(chnId, uCtrlType, nValue);
  TChannelCmd.tryGetError(ret, msgName);
end;

class function TDevCtrlCmd.SetDevCtrl(chnId: BRIINT16; uCtrlType:longint; nValue:longint):longint;
const FMT = 'SetDevCtrl: channel=%d, CtrlType=%d, value=%d. Result(%d)';
begin
  Result := CPC_SetDevCtrl(chnId, uCtrlType, nValue);
  ShowMsg(chnId, format(FMT, [chnId, uCtrlType, nValue, Result]));
end;

class procedure TDevCtrlCmd.hookup(chnId: BRIINT16; const dohook: boolean);
begin
  // 摘机、接听电话
  //CPC_SetDevCtrl(channellist.ItemIndex,CPC_CTRL_DOHOOK,Integer(dohook.Checked));
  trySetDevCtrl(chnId, CPC_CTRL_DOHOOK, Integer(dohook), '接听来电');
end;

class procedure TDevCtrlCmd.hangup(chnId: BRIINT16; const dophone: boolean);
begin
  // 挂断电话机
  //CPC_SetDevCtrl(channellist.ItemIndex,CPC_CTRL_DOPHONE,Integer(NOT dophone.Checked));
  trySetDevCtrl(chnId, CPC_CTRL_DOPHONE, Integer(dophone), '断开来电');
end;

{procedure TCallManagerBase.trySetParam(uCtrlType:longint; nValue:longint; const msgName: string);
var ret: longint;
begin
  ret := SetParam(uCtrlType, nValue);
  tryGetError(ret, msgName);
end;

function TCallManagerBase.SetParam(uParamType, nValue: longint): longint;
begin
  ShowMsg(FChanelId, 'SetParam: ' + IntToStr(uParamType) + '=' + IntToStr(nValue)
    + ', begin...');
  Result := CPC_SetParam(FChanelId, uParamType, nValue);
  ShowMsg(FChanelId, 'SetParam: ' + IntToStr(uParamType) + '=' + IntToStr(nValue)
    + ', end. Return(' + IntToStr(Result) + ')');
end;}


end.


