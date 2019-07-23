unit uChannelCmd;

interface

uses
  brisdklib, channeldata;

type
  TChannelCmd = class
  private
    class procedure tryGetError(const ret: longint; const msgName: string); static;
  public
    { Public declarations }
    //class function fmtEvent(const evData: TBriEvent_Data; const full: boolean=true): string; static;
    //class function fmtEvent(const evData: TBriEvent_Data;
    //  const callLogInf: TCallLogInf; const full: boolean=true): string; overload; static;
    //class function fmtEvent(const evData: TBriEvent_Data): string; overload; static;
    class function fmtEvent(const evData: TBriEvent_Data; const ct, cr: smallint;
      const uuid: string): string; overload;
  end;

  TGeneralCmd = class
  private
  public
    { Public declarations }
    class function General(uChnId: BRIINT32; uGeneralType:longint;
      nValue:longint; pValue:BRIPCHAR8):longint; overload;
    class function General(uChnId: BRIINT32; uGeneralType:longint):longint; overload;
    class function tryGeneral(uChnId: BRIINT32; uGeneralType:longint; const msgName: string):longint; overload;
    class function tryGeneral(uChnId: BRIINT32; uGeneralType:longint;
      nValue:longint; pValue:BRIPCHAR8; const msgName: string):longint; overload;
    class function isRefUseing(uChnId: BRIINT32): longint; static;
    class function getCallId(uChnId: BRIINT32): string; static;
    class function getDialCodeEx(uChnId: BRIINT32): string; static;
    class function lineHook(uChnId: BRIINT32): longint; static;
    class function lineFree(uChnId: BRIINT32): longint; static;
    class procedure tryRefuseCallIn(uChnId: BRIINT32); static;
    class function reloadCfg(uChnId: BRIINT32): longint; static;
  end;

  TDevCtrlCmd = class
  private
  public
    { Public declarations }
    class function getDevCtrl(uChnId: BRIINT32; uCtrlType: longint): longint;
    class procedure tryGetDevCtrl(uChnId: BRIINT32; uCtrlType: longint;
      const msgName: string); static;
    class procedure trySetDevCtrl(uChnId: BRIINT32; uCtrlType:longint; nValue:longint; const msgName: string);
    class function setDevCtrl(uChnId: BRIINT32; uCtrlType:longint; nValue:longint):longint;
    class procedure doHook(uChnId: BRIINT32; const b: boolean); static;
    class procedure doPhone(uChnId: BRIINT32; const b: boolean); static;
  end;

  TCallLogCmd = class
  private
    class function CallLog(uChnId: BRIINT32; uLogType:longint;
      pValue: BRIPCHAR8; nValue: longint): longint; overload;
    class function CallLog(uChnId: BRIINT32; uLogType:longint): longint; overload;
    //class function tryGetCallId(uChnId: BRIINT32): string; static;
  public
    { Public declarations }
    class function resetCall(uChnId: BRIINT32): longint; static;
    //
    class function getCallType(uChnId: BRIINT32): longint; static;
    class function getCallResult(uChnId: BRIINT32): longint; static;
    class function cr(uChnId: BRIINT32): longint; static;
    class function getCallId(uChnId: BRIINT32): string; static;
    //
    class function getConnectedTime(uChnId: BRIINT32): longint; static;
    class function getBeginTime(uChnId: BRIINT32): longint; static;
    class function getEndTime(uChnId: BRIINT32): longint; static;
    class function getRingBackTime(uChnId: BRIINT32): longint; static;
    //
    //class function getCallLogInfo(uChnId: BRIINT32; const evType: BRIINT32): TCallLogInf; static;
  end;

  TCallFileRec = class
  private
  public
    class function startRecord(const uChnId: BRIINT32; const fileEcho: boolean;
      const fileAgc: boolean; const recFileFmt: integer; const fileName: string): longint;
    class function endRecord(const uChnId: BRIINT32; const lRecFileId: longint;
      const quiet: boolean=false): longint;
    class function getRecFileLen(const uChnId: BRIINT32; const lRecFileID: longint): longint;
  end;

implementation

uses Windows, SysUtils, StrUtils, uShowMsgBase, uCharComm, uEventTypeMap, DateUtils,
  uDateTimeUtils, uLog4me;

{ TChannelCmd }

procedure ShowSysLog(const S: String);
begin
  //g_ShowMsgBase.ShowMsg(S);
end;

procedure ShowMsg(uChnId: BRIINT32; const S: String);
begin
  //ShowSysLog('通道' + IntToStr(uChnId) + ', ' + S);
end;

{class function TChannelCmd.fmtEvent(const evData: TBriEvent_Data; const full: boolean): string;
  function getSimple(): string;
  const FMT_STR = 'channl=%d'
    + ', tName=%s, tId=%d'
    + ', handle=%d, result=%d, param=%d'
    + ', szData=%s, szDataEx=%s'
    //+ ', linehook=%d, linefree=%d'
    ;
  var uChnId: BRIINT32;
  begin
    chanId := evData.uuChnId;
    Result := format(FMT_STR, [evData.uuChnId
      , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
      //, TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId)
    ]);
  end;
  function getFull(): string;
  const FMT_STR = 'channl=%d'
    + ', tName=%s, tId=%d'
    + ', handle=%d, result=%d, param=%d'
    + ', szData=%s, szDataEx=%s'
    //+ ', linehook=%d, linefree=%d'
    + ', callType=%d, callResult=%d'
    ;
  var uChnId: BRIINT32;
  begin
    chanId := evData.uuChnId;
    Result := format(FMT_STR, [evData.uuChnId
      , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
      //, TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId)
      , TCallLogCmd.getCallType(chanId), TCallLogCmd.getCallResult(chanId)
    ]);
  end;
begin
  if full then begin
    Result := getFull();
  end else begin
    Result := getSimple();
  end;
end;}

{class function TChannelCmd.fmtEvent(const evData: TBriEvent_Data;
  const callLogInf: TCallLogInf; const full: boolean): string;
  function getSimple(): string;
  const FMT_STR = 'channl=%d'
    + ', tName=%s, tId=%d'
    + ', handle=%d, result=%d, param=%d'
    + ', szData=%s, szDataEx=%s';
  begin
    Result := format(FMT_STR, [evData.uChnId
      , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
    ]);
  end;
  function getFull(): string;
  const FMT_STR = 'channl=%d'
    + ', tName=%s, tId=%d'
    + ', handle=%d, result=%d, param=%d'
    + ', szData=%s, szDataEx=%s'
    //+ ', linehook=%d, linefree=%d'
    + ', callType=%d, callResult=%d'
    ;
  begin
    Result := format(FMT_STR, [evData.uChnId
      , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
      //, TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId)
      , callLogInf.callType, callLogInf.callResult
    ]);
  end;
begin
  if full then begin
    Result := getFull();
  end else begin
    Result := getSimple();
  end;
end;}

{class function TChannelCmd.fmtEvent(const evData: TBriEvent_Data): string;
  function getSimple(): string;
  const FMT_STR = 'channl=%d'
    + ', tName=%s, tId=%d'
    + ', handle=%d, result=%d, param=%d'
    + ', szData=%s, szDataEx=%s';
  begin
    Result := format(FMT_STR, [evData.uChnId
      , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
    ]);
  end;
begin
  Result := getSimple();
end;}

class function TChannelCmd.fmtEvent(const evData: TBriEvent_Data; const ct, cr: smallint;
    const uuid: string): string;
  function getSimple(): string;
  const FMT_STR = 'channl=%d'
    + ', tName=%s, tId=%d'
    + ', handle=%d, result=%d, param=%d'
    + ', szData=%s, szDataEx=%s'
    + ', callType=%d, callResult=%d'
    + ', uuid=%s'
    ;
  begin
    Result := format(FMT_STR, [evData.uChnId
      , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
      , evData.lEventHandle, evData.lResult, evData.lParam
      , toStr(evData.szData), toStr(evData.szDataEx)
      , ct, cr
      , uuid
    ]);
  end;
begin
  Result := getSimple();
end;

class procedure TChannelCmd.tryGetError(const ret: longint; const msgName: string);
begin
  if ret <= 0 then begin
    raise Exception.Create(msgName + '失败，错误码(' + IntToStr(ret) + ').');
  end;
end;

{ TGeneralCmd }

class function TGeneralCmd.General(uChnId: BRIINT32; uGeneralType, nValue: longint;
  pValue: BRIPCHAR8): longint;
const FMT = 'CPC_General: channel=%d, GeneralType=%d, value=%d. Result(%d)';
begin
  Result := CPC_General(uChnId, uGeneralType, nValue, pValue);
  ShowMsg(uChnId, format(FMT, [uChnId, uGeneralType, nValue, Result]));
end;

class function TGeneralCmd.General(uChnId: BRIINT32; uGeneralType: longint): longint;
begin
  Result := General(uChnId, uGeneralType, 0, '');
end;

class function TGeneralCmd.tryGeneral(uChnId: BRIINT32; uGeneralType,
  nValue: longint; pValue: BRIPCHAR8; const msgName: string): longint;
begin
  Result := General(uChnId, uGeneralType, nValue, pValue);
  if Result <= 0 then begin
    TChannelCmd.tryGetError(Result, msgName);
  end;
end;

class function TGeneralCmd.tryGeneral(uChnId: BRIINT32; uGeneralType: longint;
  const msgName: string): longint;
begin
  Result := General(uChnId, uGeneralType);
  if Result <= 0 then begin
    TChannelCmd.tryGetError(Result, msgName);
  end;
end;

class function TGeneralCmd.isRefUseing(uChnId: BRIINT32): longint;
begin
  Result := General(uChnId, CPC_GENERAL_ISREFUSEING);
end;

class function TGeneralCmd.getCallId(uChnId: BRIINT32): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := General(uChnId, CPC_GENERAL_GETCALLID, MAX_BRIEVENT_DATA, @szData);
  if ret <= 0 then begin
    raise Exception.Create('获取来电号码失败，错误码(' + IntToStr(ret) + ').');
  end;
  Result := toStr(szData);
end;

class function TGeneralCmd.getDialCodeEx(uChnId: BRIINT32): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := General(uChnId, CPC_GENERAL_GETTELDIALCODEEX, MAX_BRIEVENT_DATA, @szData);
  if ret <= 0 then begin
    raise Exception.Create('获取已拨号码失败，错误码(' + IntToStr(ret) + ').');
  end;
  Result := toStr(szData);
end;

class function TGeneralCmd.lineHook(uChnId: BRIINT32): longint;
begin
  Result := General(uChnId, CPC_GENERAL_ISLINEHOOK);
end;

class function TGeneralCmd.reloadCfg(uChnId: BRIINT32): longint;
begin
  //CPC_General(0, 100 , 0, "cpcini\\cpcconfig.ini")
  Result := General(uChnId, CPC_GENERAL_READPARAM, 0, 'cpcini\cpcconfig.ini');
end;

class function TGeneralCmd.lineFree(uChnId: BRIINT32): longint;
begin
  Result := General(uChnId, CPC_GENERAL_ISLINEFREE);
end;

class procedure TGeneralCmd.tryRefuseCallIn(uChnId: BRIINT32);
begin
  if TDevCtrlCmd.GetDevCtrl(uChnId, CPC_CTRL_RINGTIMES) <= 0 then begin
	  raise Exception.Create('没有来电，无效的拒接');
  end else begin
    // REFUSE_ASYN, REFUSE_SYN
    tryGeneral(uChnId, CPC_GENERAL_STARTREFUSE, REFUSE_SYN, NULL, '拒绝来电');
  end;
end;

{TCallLogCmd}

class function TCallLogCmd.CallLog(uChnId: BRIINT32; uLogType:longint; pValue:BRIPCHAR8; nValue:longint): longint;
const FMT = 'CPC_CallLog: channel=%d, logType=%d, value=%d. Result(%d)';
begin
  Result := CPC_CallLog(uChnId, uLogType, pValue, nValue);
  ShowMsg(uChnId, format(FMT, [uChnId, uLogType, nValue, Result]));
end;

class function TCallLogCmd.CallLog(uChnId: BRIINT32; uLogType: longint): longint;
begin
  Result := CallLog(uChnId, uLogType, NULL, 0);
end;

class function TCallLogCmd.getCallResult(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_CALLRESULT);
end;

class function TCallLogCmd.cr(uChnId: BRIINT32): longint;
begin
  Result := getCallResult(uChnId);
end;

class function TCallLogCmd.getCallType(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_CALLTYPE);
end;

class function TCallLogCmd.getRingBackTime(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_RINGBACKTIME);
end;

class function TCallLogCmd.getConnectedTime(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_CONNECTEDTIME);
end;

class function TCallLogCmd.getBeginTime(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_BEGINTIME);
end;

class function TCallLogCmd.getEndTime(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_ENDTIME);
end;

class function TCallLogCmd.resetCall(uChnId: BRIINT32): longint;
begin
  Result := CallLog(uChnId, CPC_CALLLOG_RESET);
end;

class function TCallLogCmd.getCallId(uChnId: BRIINT32): string;
var ret: longint;
  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
begin
  //char szBuf[128];//分配保存号码内存足够长度
  ret := CallLog(uChnId, CPC_CALLLOG_CALLID, @szData, MAX_BRIEVENT_DATA);
  if ret > 0 then begin
    Result := toStr(szData);
  end else begin
    Result := '';
  end;
end;

{class function TCallLogCmd.getCallLogInfo(uChnId: BRIINT32; const evType: BRIINT32): TCallLogInf;
  function rstInf2LogInfS(const u: TCallRstInf): TCallLogInf;
  var r: TCallLogInf;
  begin
    r.callResult := u.callResult;
    Result := r;
  end;
var r: TCallRstInf;
begin
  if (evType=BriEvent_CallLog) then begin // or (evType=BriEvent_PhoneHang)
    r.callResult := getCallResult(uChnId);
    //r.callId := getCallId(uChnId);
    //
    Result := rstInf2LogInfS(r);
    ShowMsg(uChnId, 'aft: ' + r.toJson);
//  end else begin
//    r.callType := getCallType(uChnId);
//    r.callResult := getCallResult(uChnId);
//    Result := rstInf2LogInfS(r);
  end;
end;}
{  function rstInf2LogInfS(const u: TCallRstInf): TCallLogInf;
  var r: TCallLogInf;
  begin
    r.callType := u.callType;
    r.callResult := u.callResult;
    Result := r;
  end;

  function rstInf2LogInfC(const u: TCallRstInf): TCallLogInf;
  var r: TCallLogInf;
  begin
    r.callType := u.callType;
    r.callResult := u.callResult;
    //
    r.beginTime := u.beginTime;
    r.ringBackTime := u.ringBackTime;
    r.connectedTime := u.connectedTime;
    r.endTime := u.endTime;
    Result := r;
  end;

var r: TCallRstInf;
begin
  if (evType=BriEvent_CallLog) then begin // or (evType=BriEvent_PhoneHang)
  //if (evType=BriEvent_PSTNFree) then begin // or (evType=BriEvent_PhoneHang)
      // or (evType=BriEvent_RemoteHang) then begin
    r.beginTime := getBeginTime(uChnId);
    r.ringBackTime := getRingBackTime(uChnId);
    r.connectedTime := getConnectedTime(uChnId);
    r.endTime := getEndTime(uChnId);
    //
    r.callType := getCallType(uChnId);
    r.callResult := getCallResult(uChnId);
    //r.callId := getCallId(uChnId);
    //
    Result := rstInf2LogInfC(r);
    ShowMsg(uChnId, 'aft: ' + r.toJson);
  end else begin
    r.callType := getCallType(uChnId);
    r.callResult := getCallResult(uChnId);
    Result := rstInf2LogInfS(r);
  end;
end;}

//class function TCallLogCmd.tryGetCallId(uChnId: BRIINT32): string;
//var ret: longint;
//  szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8;
//begin
//  //char szBuf[128];//分配保存号码内存足够长度
//  ret := CallLog(uChnId, CPC_CALLLOG_CALLID, @szData, MAX_BRIEVENT_DATA);
//  if ret <= 0 then begin
//    raise Exception.Create('获取来电号码失败，错误码(' + IntToStr(ret) + ').');
//  end;
//  Result := toStr(szData);
//end;

{class function TCallLogCmd.fmtCallLog(const evData: TBriEvent_Data): string;
begin
  Result := TChannelCmd.fmtEvent(evData, true);
end;}

{class function TCallLogCmd.fmtCallLog(uChnId: BRIINT32): string;
const FMT_STR = ''
  //+ 'linehook=%d, linefree=%d, '
  + 'callType=%d, callResult=%d'
  ;
begin
  Result := format(FMT_STR, [
    //TGeneralCmd.lineHook(chanId), TGeneralCmd.lineFree(chanId),
    getCallType(chanId), getCallResult(chanId)
  ]);
end;}

{ TDevCtrlCmd }

class function TDevCtrlCmd.GetDevCtrl(uChnId: BRIINT32; uCtrlType: longint): longint;
const FMT = 'GetDevCtrl: channel=%d, CtrlType=%d. Result(%d)';
begin
  Result := CPC_GetDevCtrl(uChnId, uCtrlType);
  ShowMsg(uChnId, format(FMT, [uChnId, uCtrlType, Result]));
end;

class procedure TDevCtrlCmd.tryGetDevCtrl(uChnId: BRIINT32; uCtrlType: longint; const msgName: string);
var ret: longint;
begin
  ret := GetDevCtrl(uChnId, uCtrlType);
  TChannelCmd.tryGetError(ret, msgName);
end;

class procedure TDevCtrlCmd.trySetDevCtrl(uChnId: BRIINT32; uCtrlType:longint;
  nValue:longint; const msgName: string);
var ret: longint;
begin
  ret := SetDevCtrl(uChnId, uCtrlType, nValue);
  TChannelCmd.tryGetError(ret, msgName);
end;

class function TDevCtrlCmd.SetDevCtrl(uChnId: BRIINT32; uCtrlType:longint; nValue:longint):longint;
const FMT = 'SetDevCtrl: channel=%d, CtrlType=%d, value=%d. Result(%d)';
begin
  Result := CPC_SetDevCtrl(uChnId, uCtrlType, nValue);
  ShowMsg(uChnId, format(FMT, [uChnId, uCtrlType, nValue, Result]));
end;

class procedure TDevCtrlCmd.doHook(uChnId: BRIINT32; const b: boolean);
  function getMsg(): string;
  begin
    if b then begin
      Result := '软摘机';
    end else begin
      Result := '软挂机';
    end;
  end;
begin
  trySetDevCtrl(uChnId, CPC_CTRL_DOHOOK, Integer(b), getMsg());   // 摘机、挂机
end;

class procedure TDevCtrlCmd.doPhone(uChnId: BRIINT32; const b: boolean);
begin
  trySetDevCtrl(uChnId, CPC_CTRL_DOPHONE, Integer(b),
    IfThen(b, '线路连接', '线路断开')      // 线路连接、线路断开
  );
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

{ TCallFileRec }

class function TCallFileRec.startRecord(const uChnId: BRIINT32;
  const fileEcho: boolean; const fileAgc: boolean; const recFileFmt: integer;
  const fileName: string): longint;
var
  lMask: longint;
  lFormat: longint;
begin
  lMask := 0;  //RECORD_MASK_ECHO | RECORD_MASK_AGC
  if Integer(fileEcho) > 0 then begin
    lMask := (lMask OR RECORD_MASK_ECHO);
  end;

  if Integer(fileAgc) > 0 then begin
    lMask := (lMask OR RECORD_MASK_AGC);
  end;

  lFormat := recFileFmt;  //FPhoneConfig.recFileFormat;
  try
    Result := CPC_RecordFile(uChnId, CPC_RECORD_FILE_START, lFormat,
      lMask, BRIPCHAR8(AnsiString(fileName)));
  except
    on E: Exception do begin
      log4error('startRecord: ' + e.Message);
    end;
  end;
end;

class function TCallFileRec.endRecord(const uChnId: BRIINT32; const lRecFileId: longint;
  const quiet: boolean): longint;

  function endRecord(const uChnId: BRIINT32; const lRecFileId: longint): longint;
  begin
    try
      Result := CPC_RecordFile(uChnId, CPC_RECORD_FILE_STOP, lRecFileID, 0, NULL);
    except
      on E: Exception do begin
        log4error('endRecord: ' + e.Message);
      end;
    end;
  end;

  function endRecordQuiet(const uChnId: BRIINT32; const lRecFileId: longint): longint;
  begin
    try
      Result := CPC_RecordFile(uChnId, CPC_RECORD_FILE_STOP, lRecFileID, 0, NULL);
    except
      on E: Exception do begin
        //log4error('endRecordQuiet: ' + e.Message);
      end;
    end;
  end;

begin
	if (lRecFileID > 0) then begin
    if quiet then begin
      Result := endRecordQuiet(uChnId, lRecFileId);
    end else begin
      Result := endRecord(uChnId, lRecFileId);
    end;
    //ShowMsg(uChnId, format('停止文件录音%s, Result=%d, handle=%d',
    //  [IfThen(Result>0, '成功', '失败'), Result, lRecFileID]));
	end else begin
    Result := 0;
  end;
end;

class function TCallFileRec.getRecFileLen(const uChnId: BRIINT32; const lRecFileID: longint): longint;
begin
  Result := 0;
	if (lRecFileID > 0) then begin
    try
      Result := CPC_RecordFile(uChnId, CPC_RECORD_FILE_ELAPSE, lRecFileID, 0, NULL);
    except
      on E: Exception do begin
        log4error('getRecFileLen: ' + e.Message);
      end;
    end;
  end;
  //ShowMsg(uChnId, format('获取文件录音时长 %d s, handle=%d', [Result, lRecFileID]));
end;

end.


