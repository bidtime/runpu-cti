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
    tryGeneral(CPC_GENERAL_STARTDIAL, 0, BRIPCHAR8(AnsiString(phoneNo)), '����绰');
  end;

  procedure tryCanStartDialup();
  var ret: longint;
  begin
    ret := General(CPC_GENERAL_ISDIALING);   //����Ƿ����ڲ���/���β���
    if (ret = 1) then begin
      raise Exception.Create('����绰' + 'ʧ�ܣ�������(' + IntToStr(ret) + ')�����ڲ�����.');
    end else if (ret <> 0) then begin
    //end else begin
      raise Exception.Create('����绰' + 'ʧ�ܣ�������(' + IntToStr(ret) + ')������֪����״̬.');
    end;
  end;

  // TDevCtrlCmd.tryGetDevCtrl(FChanelId, CPC_CTRL_PHONE, '');
  procedure tryTestDialDevType();

    procedure showCtrlPhoneLog(const ret: longint);
    begin
      if ( ret = 1 ) then begin    // ��ժ��״̬
        ShowMsg('��⵽��ժ��', true);
      end else begin
        ShowMsg('--------------------------', true);
        if ( ret = 0 ) then begin
          ShowMsg('��⵽δժ��', true);
        end else begin
          ShowMsg('���ժ��״̬ʧ��: ״̬��=' + IntToStr(ret), true);
        end;
      end;
    end;

  var ret: longint;
  begin
    ret := CPC_GetDevCtrl(FChanelId, CPC_CTRL_PHONE);
    if (self.FDevType = DEVTYPE_IR1) then begin
      if ( ret < 0) then begin
        raise Exception.Create('����绰' + 'ʧ�ܣ���ȡժ��״̬��������(' + IntToStr(ret) + ').');
      end else if ( ret = 0 ) then begin
        raise Exception.Create('����绰ǰ����⵽δժ��״̬.');
      end else if ( ret = 1 ) then begin
        //showMessage('����绰ǰ����ժ��״̬.');
      end;
    end else begin

    end;
  end;

begin
  if SameText(phoneNo, '') then begin
    raise Exception.Create('�绰���벻��Ϊ��'); //���������,һ�����ſ����ӳ�1��'
  end else begin
    tryCanStartDialup();
    tryTestDialDevType();
//    if g_LocalCallEv.validUUID then begin
//      raise Exception.Create('�绰�����У��Ժ��ٲ�');
//    end;
    // StartDial set new val.
    g_LocalCallEv.resetVal(false);
    //g_LocalCallEv.setCallType( CALLT_CALLOUT );
    g_LocalCallEv.callUuid := uuid;
    g_LocalCallEv.FromPhone := g_phoneConfig.callingNo;
    g_LocalCallEv.ToPhone := phoneNo;
    g_LocalCallEv.callLog := 'ȥ�翪ʼ';
    g_LocalCallEv.saveToUUIDFile;
    //
    //ShowMsg('--------------------------', true);
    if not (g_LocalCallEv.start_prefix.IsEmpty) then begin
      ShowMsg(g_LocalCallEv.testPrefix, true);
    end;
    ShowMsg(format('���յ�ȥ������: %s, %s', [uuid, phoneNo]), true);
    //tryStartDialup(self.PhoneConfig.OutPrefix + prefix + phoneNo);
    tryStartDialup(prefix + phoneNo);
  end;
end;

procedure TCallManager.stopDialup();

  procedure tryStopDialup();
  begin
    tryGeneral(CPC_GENERAL_STOPDIAL, 0, NULL, 'ֹͣ����');
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
    raise Exception.Create('uuid����Ϊ��');
  end else begin
    g_LocalCallEv.confirmCallIn(uuid);
  end;
end;

procedure TCallManager.confirmDial(const uuid: string);
begin
  if SameText(uuid, '') then begin
    raise Exception.Create('uuid����Ϊ��');
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
  TDevCtrlCmd.doHook(self.FChanelId, b);   // ժ���������绰
end;

procedure TCallManager.doPhone(const b: boolean);
begin
  TDevCtrlCmd.doPhone(self.FChanelId, b);  // �Ҷϵ绰��
end;

end.


