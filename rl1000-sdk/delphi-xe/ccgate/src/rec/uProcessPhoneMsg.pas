unit uProcessPhoneMsg;

interface

uses
  Classes, Windows, Messages, brisdklib, channeldata, uPhoneConfig, uPhoneRecFileAuto,
  uLocalRemoteCallEv, uResultDTO, uCmdResponse, uQueueTimer;

type
  TProcessPhoneMsg = class(TPhoneRecFileAuto)
  private
    FLog: boolean;
    FQueueTimer: TQueueStrTimer;
    procedure ShowMsgQ(const uChnId: BRIINT32; const cmd, msg: string;
      const attachLog: boolean=false); overload;
    procedure ShowMsgQ(const uChnId: BRIINT32; const cmd,msg,val: string;
      const attachLog: boolean=false); overload;
    procedure ProcessMsgProc(const evData: TBriEvent_Data);
    procedure ShowMsgQ_callStart(const uChnId: BRIINT32; const cmd, msg, val,
      phone: string);
    procedure ShowMsgQ_Data<T>(const uChnId: BRIINT32; const cmd, msg: string;
      const data: T; const attachLog: boolean=false);
    procedure ShowMsgLogQ(const uChnId: BRIINT32; const msg: String;
      const attachLog: boolean=false);
    procedure ShowMsgStateQ(const uChnId: BRIINT32; const msg: String;
      const attachLog: boolean=false);
    procedure doMsgA(const lPar: LPARAM);
    procedure OnProcessJson(const json: string);
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
    procedure MyMsgProc(var Msg: TMessage);
  end;

implementation

uses SysUtils, StrUtils, uCmdType, uCharComm, uEventTypeMap, uChannelCmd,
  uFrmMain, uComObj;

{ TProcessPhoneMsg }

constructor TProcessPhoneMsg.Create();
begin
  inherited create;
  FLog := true;
  FQueueTimer := TQueueStrTimer.Create;
  FQueueTimer.OnGetQueue := OnProcessJson;
  //
  FQueueTimer.setInterv(g_PhoneConfig.hangAftInterv * TTimeCfg.second);
end;

destructor TProcessPhoneMsg.Destroy;
begin
  FQueueTimer.Free;
  inherited;
end;

procedure TProcessPhoneMsg.doMsgA(const lPar: LPARAM);
var
  pEvent: PTBriEvent_Data;
begin
  pEvent := PTBriEvent_Data(lPar);
  try
    //QNV_Event(uuChnId, QNV_EVENT_POP, 0, NULL, @e, 0);  //演示主动获取事件函数方式,侦听显示消息
    ProcessMsgProc(pEvent^);
  except
    on e: exception do begin
      ShowMsgLogQ(pEvent^.uChnId, e.Message);
    end;
  end;
end;

procedure TProcessPhoneMsg.MyMsgProc(var Msg: TMessage);
var lPar: LPARAM;
begin
  lPar := Msg.LParam;
  TThread.Synchronize(nil,
  procedure
  begin
    doMsgA(lPar);
  end);
end;

procedure TProcessPhoneMsg.OnProcessJson(const json: string);
begin
  TLocalRemoteCallEV.upload(json);
end;

procedure TProcessPhoneMsg.ProcessMsgProc(const evData: TBriEvent_Data);

  procedure AStartRec(const uChnId: BRIINT32; const msg: string);
  var h: longint;
    S: string;
  begin
    g_LocalCallEv.startRec;      // 开启录音
    g_LocalCallEv.callLog := msg;
    if (g_LocalCallEv.validUUID) then begin
      h := inherited autoSaveRec(uChnId, g_LocalCallEv.resFileName, msg);
      g_LocalCallEv.fileHandle := h;
      g_LocalCallEv.saveToUUIDFile;
      S := IfThen(h>0, 'true', 'false');
    end else begin
      S := 'none';
    end;
    ShowMsgLogQ(uChnId, format('startRec=%s, %s', [S, g_LocalCallEv.getFmtTime]), true);
  end;

  procedure AEndRec(const uChnId: BRIINT32; const msg: string);
  var l: longint;
    S: string;
  begin
    g_LocalCallEv.endRec;
    g_LocalCallEv.callLog := msg;
    if (g_LocalCallEv.validUUID) then begin
      l := inherited autoEndRec(uChnId, g_LocalCallEv.resFileName, msg);  // 挂机后，结束录音
      g_LocalCallEv.saveToUUIDFile;
      S := IfThen(l>0, 'true', 'false');
    end else begin
      S := 'none';
    end;
    ShowMsgLogQ(uChnId, format('endRec=%s, %s', [S, g_LocalCallEv.getFmtTime]), true);
  end;
var
  uChnId: BRIINT32;
  json, S: string;
begin
  uChnId := evData.uChnId;
  if (evData.lEventType=BriEvent_SystemOther) then begin
    if ((evData.lResult = 12) and (evData.lParam=0))
        or (evData.lResult = 14) and (evData.lParam=1) then begin
      if not (g_LocalCallEv.start_prefix.IsEmpty) then begin
        ShowMsg(g_LocalCallEv.testPrefix, true);
        inherited ShowMsgQ('');
      end;
    end;
  end;
  ShowMsgStateQ(uChnId, TChannelCmd.fmtEvent(evData, g_LocalCallEv.callType,
    g_LocalCallEv.callResult, g_LocalCallEv.callUuid), true);
  case evData.lEventType of
    BriEvent_PhoneHook: begin            // 本地摘机
      if CPC_General(uChnId, CPC_GENERAL_ISSTARTDIAL, 0, NULL) = 0 then begin
        CPC_SetDevCtrl(uChnId, CPC_CTRL_DOHOOK, 0);
        S := '本地话机摘机，自动软挂机，禁止带耳麦的设备进行三方通话';
      end else begin
        S := '本地话筒摘机';
      end;
      ShowMsgQ(uChnId, EV_LOCAL_PHONE_HOOK, S);
      //
      if (g_LocalCallEv.validUUID) and (g_LocalCallEv.callType = CALLT_CALLIN) then begin
        if g_LocalCallEv.crConnect(TCallLogCmd.cr(uChnId)) then begin
          AStartRec(uChnId, '本地话筒摘机, 来电接通, 开始录音');
          ShowMsgQ_callStart(uChnId, EV_CALL_IN_ESTABLISHED,
            '本地话筒摘机, 来电接通', g_LocalCallEv.CallUUID, g_LocalCallEv.FromPhone);
        end;
      end;
    end;
    BriEvent_PhoneHang: begin            // 本地挂机
      CPC_SetDevCtrl(uChnId, CPC_CTRL_DOHOOK, 0);
      //
      g_LocalCallEv.setCallResult( TCallLogCmd.cr(uChnId) );
      if (g_LocalCallEv.validUUID) then begin
        AEndRec(uChnId, '本地挂机, 结束录音');
      end;
      json := g_LocalCallEv.toJsonV;
      ShowMsgQ_Data(uChnId, EV_PSTNFree, '设备空闲, 通话结束.',
        TLocalRemoteCallEv.fromJson(json), true);  // it auto free TLocalRemoteCallEv.fromJson(json)
      //
      ShowMsgQ(uChnId, EV_LOCAL_PHONE_HANG, '本地话筒挂机');
      //TLocalRemoteCallEv.upload(json);
      // TODO 这段代码要废除
      if (g_LocalCallEv.callType = CALLT_CALLIN) then begin
        ShowMsgQ_callStart(uChnId, EV_CALL_IN_END,
          '本地挂机, 通话结束.', g_LocalCallEv.CallUUID, g_LocalCallEv.FromPhone);
      end;
      // resetVal
      if g_LocalCallEv.validUUID then begin
        self.FQueueTimer.put(json);
      end;
      g_LocalCallEv.resetVal(true);
      // resetCall
      //TCallLogCmd.resetCall(uChnId);
      //ShowMsgLogQ(uChnId, '重置通话日志.');
    end;
    BriEvent_DoStartDial: begin          // 开始拨号
      if (g_LocalCallEv.validUUID) then begin
        ShowMsgLogQ(uChnId, format('DoStartDial, %s', [g_LocalCallEv.getFmtTime]), true);
        if (evData.lResult = 0) then begin
          g_LocalCallEv.startDial;
          ShowMsgLogQ(uChnId, format('startDial=%s', [g_LocalCallEv.getFmtTime]), true);
          ShowMsgQ(uChnId, EV_CALL_OUT_START_DIAL, format('去电拨号开始 %d 次', [evData.lResult]));
        end else begin
          ShowMsgQ(uChnId, EV_CALL_OUT_START_DIAL, format('去电拨号静音 %d 次', [evData.lResult]));
        end;
      end;
    end;
    BriEvent_RingBack: begin
      g_LocalCallEv.startRing;
      ShowMsgLogQ(uChnId, format('startRing=%s', [g_LocalCallEv.getFmtTime]), true);
      if (g_LocalCallEv.validUUID) then begin
        ShowMsgQ(uChnId, EV_CALL_OUT_RING_BACK, '拨号结束，检测到回铃');
      end;
    end;
    BriEvent_CallIn: begin               // 来电产生
      if evData.szData[1] = '0' then begin
        if (evData.lResult = 1) then begin
          // start CALLT_CALLIN
          ShowMsg('--------------------------', true);
          ShowMsgLogQ(uChnId, 'CallIn reset g_LocalCallEv.');
          g_LocalCallEv.resetVal(false);
          g_LocalCallEv.callUuid := newUUID(false);
          g_LocalCallEv.setCallType( CALLT_CALLIN );
          g_LocalCallEv.FromPhone := '00000001';
          g_LocalCallEv.ToPhone := g_phoneConfig.callingNo;
          g_LocalCallEv.callLog := '来电开始';
          g_LocalCallEv.saveToUUIDFile;
          //
          ShowMsg('来电开始,' + g_LocalCallEv.CallUUID + ',' + g_LocalCallEv.FromPhone, true);
          //
          ShowMsgQ_callStart(uChnId, EV_CALL_IN_START, '来电开始',
            g_LocalCallEv.CallUUID, g_LocalCallEv.FromPhone);
        end;
        ShowMsgQ_callStart(uChnId, EV_CALL_IN_RING,
          format('来电响铃第 %d 次', [evData.lResult]),
             g_LocalCallEv.CallUUID, g_LocalCallEv.FromPhone);
      end else begin
        ShowMsgQ_callStart(uChnId, EV_CALL_IN_RING,
          format('来电静音第 %d 次', [evData.lResult]),
             g_LocalCallEv.CallUUID, g_LocalCallEv.FromPhone);
      end;
    end;
    BriEvent_GetCallID: begin
      g_LocalCallEv.FromPhone := toStr(evData.szData);
      ShowMsgQ(uChnId, EV_GET_CALL_ID, '获取到来电号码', g_LocalCallEv.FromPhone);
    end;
    BriEvent_StopCallIn: begin
      ShowMsgQ(uChnId, EV_STOP_CALL_IN, '对方停止呼入产生一个未接电话', g_LocalCallEv.FromPhone);
    end;
    BriEvent_DialEnd: begin              // 拨号结束
      if CPC_GetDevCtrl(uChnId, CPC_CTRL_PHONE) > 0 then begin
        CPC_SetDevCtrl(uChnId, CPC_CTRL_DOHOOK, 0);
        //ShowMsgQ(uChnId, SHOW_STATE, '拨号结束，检测到电话机已摘着,自动软挂机，禁止带耳麦的设备进行3方通话');
      end else begin
        //ShowMsgQ(uChnId, SHOW_STATE, '拨号结束');
      end;
      // EV_CALL_OUT_DIAL_END
      if (g_LocalCallEv.validUUID) then begin
        AStartRec(uChnId, '主叫拨号结束, 开始录音');
        ShowMsgQ(uChnId, EV_CALL_OUT_DIAL_END, '拨号结束, 开始录音');
      end;
    end;
    BriEvent_RemoteHook: begin           // 被叫方摘机, 对方远程摘机
//      if evData.lResult=1 then begin     // 级性反转
//        ShowMsgLogQ(uChnId, '被叫方摘机，侦测到有级性反转');
//      end else begin
//        ShowMsgLogQ(uChnId, '被叫方摘机，侦测到无级性反转');
//      end;
      // EV_REMOTE_PHONE_HOOK
      ShowMsgQ(uChnId, EV_REMOTE_PHONE_HOOK, '被叫方摘机');
    end;
    BriEvent_RemoteHang: begin            // 被叫方挂机, 对方远程挂机
      ShowMsgQ(uChnId, EV_REMOTE_PHONE_HANG, '被叫方挂机');
    end;
    BriEvent_Busy: begin                  // 检测到忙音事件
      ShowMsgQ(uChnId, EV_REMOTE_PHONE_HANG, '检测到忙音, 被叫方挂机');
    end;
//    BriEvent_PSTNFree: begin
//    end;
//    BriEvent_CallLog: begin
//    end;
    BriEvent_RecordFile: begin
      if (evData.lResult = 2) then begin
        ShowMsgLogQ(uChnId, '');
      end;
    end;
    BriEvent_DevErr: begin               // error, 产生错误
//      g_LocalCallEv.callLog := format('设备出错: %s', [TEventTypeMap.getDevErr(evData.lResult)]);
//      g_LocalCallEv.saveToUUIDFile();
//      g_LocalCallEv.resetVal;
      ShowMsgLogQ(uChnId, TEventTypeMap.getDevErr(evData.lResult));
      if (evData.szData[1] = '1') and (evData.lResult = 0) then begin
        ShowMsgQ(TCmdResponse.successJson(EV_DEV_ERROR,
          fmtMsg(uChnId, TEventTypeMap.getDevErr(evData.lResult))));
        frmMain.errorHintM('录音盒子出错，' + TEventTypeMap.getDevErr(evData.lResult)
          + '，请检查设备后在【文件】菜单中点【启动】', 5);
      end;
      ShowMsgLogQ(uChnId, '');
    end;
  end;
  //ShowMsgQ(uChnId, EV_SHOW_STATE, '  ' + 'last,' + TChannelCmd.fmtEvent(evData, r));
end;

procedure TProcessPhoneMsg.ShowMsgStateQ(const uChnId: BRIINT32;
  const msg: String; const attachLog: boolean);
const cmd = EV_SHOW_STATE;
begin
  self.ShowMsgQ(uChnId, cmd, msg, attachLog);
end;

procedure TProcessPhoneMsg.ShowMsgLogQ(const uChnId: BRIINT32; const msg: String;
  const attachLog: boolean);
const cmd = EV_SHOW_LOG;
begin
  self.ShowMsgQ(uChnId, cmd, msg, attachLog);
end;

procedure TProcessPhoneMsg.ShowMsgQ(const uChnId: BRIINT32; const cmd: string;
  const msg: String; const attachLog: boolean);
begin
  inherited ShowMsg(uChnId, msg, attachLog);
  if FLog then begin
    inherited ShowMsgQ(TCmdResponse.successJson(cmd, fmtMsg(uChnId, msg)));
  end;
end;

procedure TProcessPhoneMsg.ShowMsgQ(const uChnId: BRIINT32;
    const cmd,msg,val: string; const attachLog: boolean);
  function getMsgA(): string;
  var S: string;
  begin
    S := cmd + '-' + msg;
    if not val.isEmpty then begin
      S := S + '(' + val + ')';
    end;
  end;
begin
  inherited ShowMsg(uChnId, getMsgA(), attachLog);
  if FLog then begin
    inherited ShowMsgQ(TCmdResponse.successJson(cmd, fmtMsg(uChnId, msg), val));
  end;
end;

procedure TProcessPhoneMsg.ShowMsgQ_callStart(const uChnId: BRIINT32;
   const cmd, msg, val, phone: string);
  function getMsgA(): string;
  var S: string;
  begin
    S := cmd + '-' + msg;

    if (not val.isEmpty) then begin
      S := cmd + '-' + msg + '(' + val + ')';
      if (not phone.isEmpty) then begin
        S := cmd + '-' + msg + '(' + val+ ', ' + phone + ')';
      end else if (True) then begin
        S := cmd + '-' + msg + '(' + val + ')';
      end;
    end;
    Result := S;
  end;
begin
  inherited ShowMsg(uChnId, getMsgA());
  if FLog then begin
    inherited ShowMsgQ(TCmdResponse.successCallInJson(cmd, fmtMsg(uChnId, msg), val, phone));
  end;
end;

procedure TProcessPhoneMsg.ShowMsgQ_Data<T>(const uChnId: BRIINT32;
  const cmd, msg: string; const data: T; const attachLog: boolean);
var S: string;
begin
  S := TCmdResponse.dataToJson<T>(cmd, msg, nil, data);
  inherited ShowMsg(uChnId, cmd + '-' + msg + '(' + S + ')', attachLog);
  if FLog then begin
    inherited ShowMsgQ(S);
  end;
end;

{procedure TProcessPhoneMsg.ShowMsgQ(const uChnId: BRIINT32; const S: String);
begin
  self.ShowMsgQ(uChnId, SHOW_STATE, S);
end;}

end.



