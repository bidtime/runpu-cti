unit uCallManager;

interface

uses
  Classes, Messages, brisdklib, channeldata, uCallManagerBase, uProcessPhoneMsg,
  uPhoneConfig, uPhoneCfgMsgBase, uShowMsgBase;

type
  TCallManager = class(TCallManagerBase)
  private
  protected
    FProPhoneMsg: TProcessPhoneMsg;
    procedure setOnShowLogs(const evShowLogs: TShowLogQueue); override;
  public
    { Public declarations }
    constructor Create(const lFrmHandle: longint);
    destructor Destroy; override;
    //
    function OpenDevice(var cfg: TPhoneConfig): boolean; override;
    procedure MyMsgProc(var Msg: TMessage);
    procedure startDialup(const prefix, phoneNo: string; const uuid: string);
    procedure stopDialup();
    //
    procedure doPhone(const b: boolean);
    procedure doHook(const b: boolean);
    procedure refuseCallIn();
    //
    procedure confirmCallIn(const uuid: string);
    procedure confirmDial(const uuid: string);
    procedure resetCall();
  end;

implementation

uses Windows, SysUtils, uCharComm, uChannelCmd, uLocalRemoteCallEv;

{ TCallManager }

constructor TCallManager.Create(const lFrmHandle: longint);
begin
  inherited create(lFrmHandle);
  FFrmHandle := lFrmHandle;
  FProPhoneMsg := TProcessPhoneMsg.Create;
end;

destructor TCallManager.Destroy;
begin
  FProPhoneMsg.Free;
  inherited;
end;

function TCallManager.OpenDevice(var cfg: TPhoneConfig): boolean;
begin
  Result := inherited OpenDevice(cfg);
  FProPhoneMsg.PhoneConfig := cfg;
end;

procedure TCallManager.MyMsgProc(var Msg: TMessage);
begin
  FProPhoneMsg.MyMsgProc(msg);
end;

procedure TCallManager.startDialup(const prefix, phoneNo: string; const uuid: string);

  procedure tryStartDialup(const phoneNo: string);
  begin
    tryGeneral(CPC_GENERAL_STARTDIAL, 0, BRIPCHAR8(AnsiString(phoneNo)), '拨打电话');
  end;

  procedure tryCanStartDialup();
  var ret: longint;
  begin
    ret := General(CPC_GENERAL_ISDIALING);   //检测是否正在拨号/二次拨号
    if (ret = 1) then begin
      raise Exception.Create('拨打电话' + '失败，错误码(' + IntToStr(ret) + ')，正在拨号中.');
    end else if (ret <> 0) then begin
    //end else begin
      raise Exception.Create('拨打电话' + '失败，错误码(' + IntToStr(ret) + ')，不可知返回状态.');
    end;
  end;

  // TDevCtrlCmd.tryGetDevCtrl(FChanelId, CPC_CTRL_PHONE, '');
  procedure tryTestDialDevType();

    procedure showCtrlPhoneLog(const ret: longint);
    begin
      if ( ret = 1 ) then begin    // 已摘机状态
        ShowMsg('检测到已摘机', true);
      end else begin
        ShowMsg('--------------------------', true);
        if ( ret = 0 ) then begin
          ShowMsg('检测到未摘机', true);
        end else begin
          ShowMsg('检测摘机状态失败: 状态码=' + IntToStr(ret), true);
        end;
      end;
    end;

  var ret: longint;
  begin
    ret := CPC_GetDevCtrl(FChanelId, CPC_CTRL_PHONE);
    if (self.FDevType = DEVTYPE_IR1) then begin
      if ( ret < 0) then begin
        raise Exception.Create('拨打电话' + '失败，获取摘机状态，错误码(' + IntToStr(ret) + ').');
      end else if ( ret = 0 ) then begin
        raise Exception.Create('拨打电话前，检测到未摘机状态.');
      end else if ( ret = 1 ) then begin
        //showMessage('拨打电话前，已摘机状态.');
      end;
    end else begin

    end;
  end;

begin
  if SameText(phoneNo, '') then begin
    raise Exception.Create('电话号码不能为空'); //请输入号码,一个逗号可以延迟1秒'
  end else begin
    tryCanStartDialup();
    tryTestDialDevType();
//    if g_LocalCallEv.validUUID then begin
//      raise Exception.Create('电话处理中，稍候再拨');
//    end;
    // StartDial set new val.
    g_LocalCallEv.resetVal(false);
    //g_LocalCallEv.setCallType( CALLT_CALLOUT );
    g_LocalCallEv.callUuid := uuid;
    g_LocalCallEv.FromPhone := g_phoneConfig.callingNo;
    g_LocalCallEv.ToPhone := phoneNo;
    g_LocalCallEv.callLog := '去电开始';
    g_LocalCallEv.saveToUUIDFile;
    //
    //ShowMsg('--------------------------', true);
    if not (g_LocalCallEv.start_prefix.IsEmpty) then begin
      ShowMsg(g_LocalCallEv.testPrefix, true);
    end;
    ShowMsg(format('接收到去电命令: %s, %s', [uuid, phoneNo]), true);
    //tryStartDialup(self.PhoneConfig.OutPrefix + prefix + phoneNo);
    tryStartDialup(prefix + phoneNo);
  end;
end;

procedure TCallManager.stopDialup();

  procedure tryStopDialup();
  begin
    tryGeneral(CPC_GENERAL_STOPDIAL, 0, NULL, '停止拨号');
  end;

begin
  tryStopDialup();
end;

procedure TCallManager.resetCall();
begin
  TCallLogCmd.resetCall(self.FChanelId);
end;

procedure TCallManager.confirmCallIn(const uuid: string);
begin
  if SameText(uuid, '') then begin
    raise Exception.Create('uuid不能为空');
  end else begin
    g_LocalCallEv.confirmCallIn(uuid);
  end;
end;

procedure TCallManager.confirmDial(const uuid: string);
begin
  if SameText(uuid, '') then begin
    raise Exception.Create('uuid不能为空');
  end else begin
    g_LocalCallEv.confirmDial(uuid);
  end;
end;

procedure TCallManager.refuseCallIn();
begin
  TGeneralCmd.tryRefuseCallIn(self.FChanelId);
end;

procedure TCallManager.setOnShowLogs(const evShowLogs: TShowLogQueue);
begin
  inherited;
  FProPhoneMsg.OnShowLogs := evShowLogs;
end;

procedure TCallManager.doHook(const b: boolean);
begin
  TDevCtrlCmd.doHook(self.FChanelId, b);   // 摘机、接听电话
end;

procedure TCallManager.doPhone(const b: boolean);
begin
  TDevCtrlCmd.doPhone(self.FChanelId, b);  // 挂断电话机
end;

end.


