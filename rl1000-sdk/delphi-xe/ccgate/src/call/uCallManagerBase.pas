unit uCallManagerBase;

interface

uses
  Classes, Messages, brisdklib, channeldata, uPhoneCfgMsgBase, uPhoneConfig;

type
  TCallManagerBase = class(TPhoneCfgMsgBase)
  private
    procedure resetVal;
  protected
    FListChannel: TStrings;
    FChanelId: BRIINT32;
    FFrmHandle: longint;
    FDevChanls: longint;
    FDevType: longint;
    //
    function InitDevice(var cfg: TPhoneConfig): boolean;
    function GetChannelModule(chid: smallint): string;
    //
    function General(uGeneralType:longint):longint;
  public
    { Public declarations }
    constructor Create(const lFrmHandle: longint);
    destructor Destroy; override;
    function OpenDevice(var cfg: TPhoneConfig): boolean; virtual;
    function restartDevice(var cfg: TPhoneConfig): boolean;
    procedure CloseDevice;
    function getChannelS(): string;
    //
    procedure tryGeneral(uGeneralType, nValue: longint; pValue: BRIPCHAR8;
      const msgName: string);
    function reloadCfg(): longint;
    //
    property ListChannel: TStrings read FListChannel write FListChannel;
    property DevType: longint read FDevType write FDevType;
    property ChanelId: BRIINT32 read FChanelId write FChanelId;
  end;

implementation

uses Windows, SysUtils, uChannelCmd;

{ TCallManagerBase }

constructor TCallManagerBase.Create(const lFrmHandle: longint);
begin
  inherited create;
  FListChannel := TStringList.create;
  resetVal();
end;

destructor TCallManagerBase.Destroy;
begin
  FListChannel.Free;
  inherited;
end;

procedure TCallManagerBase.resetVal();
begin
  self.FListChannel.Clear;
  self.FChanelId := -1;
  //self.f
  self.FDevType := DEVTYPE_UNKNOW;
  self.FDevChanls := 0;
end;

//��ʼ���豸
function TCallManagerBase.InitDevice(var cfg: TPhoneConfig): boolean;

var //e:TBriEvent_Data;
  id:BRIINT16;
begin
  Result := false;
  ShowMsg('��ʼ���豸��ʼ...');
  resetVal();
  if CPC_OpenDevice(0, 0, NULL) > 0 then begin
    FDevType := CPC_DevInfo(0, CPC_DEVINFO_GETTYPE);
    FDevChanls := CPC_DevInfo(0, CPC_DEVINFO_GETCHANNELS);
    ShowMsg('��ʼ���豸�ɹ�,�ܹ�ͨ����' + IntToStr(FDevChanls));
    // for
    for id := 0 to ( FDevChanls - 1 ) do begin
      //�����������ʱ����رտ��Ź�,��ʽ����ʱ�������Ź�
      //�������������رտ��Ź�,�ڳ���ϵ�ͣ������5��,�豸�����Զ���λ,����Ҫ���´��豸��
      if g_phoneConfig.ctrlWatchDog then begin
        ShowMsg('�Զ���λ����: ' + '����');
        CPC_SetDevCtrl(id, CPC_CTRL_WATCHDOG, 1);   // 0/1���ر�/���豸���Ź�
      end else begin
        ShowMsg('�Զ���λ����: ' + '�ر�');
        CPC_SetDevCtrl(id, CPC_CTRL_WATCHDOG, 0);   // 0/1���ر�/���豸���Ź�
      end;
      // FAmMic_idx, FAm_SpkOut_Idx
      //setParamType(id, CPC_PARAM_AM_MIC, cfg.MicAM);
      //setParamType(id, CPC_PARAM_AM_SPKOUT, cfg.SpkAM);
      //micam.ItemIndex := CPC_GetParam(id,CPC_PARAM_AM_MIC);
	    //spkam.itemindex := CPC_GetParam(id,CPC_PARAM_AM_SPKOUT);
      //
      cfg.MicAM := CPC_GetParam(id, CPC_PARAM_AM_MIC);
	    cfg.SpkAM := CPC_GetParam(id, CPC_PARAM_AM_SPKOUT);
      //
      ChannelStatus[id].lRecFileID  := -1;
      ChannelStatus[id].lPlayFileID := -1;
      CPC_Event(id, CPC_EVENT_REGWND, FFrmHandle, NULL, NULL, 0);
      //CPC_Event(id, CPC_EVENT_POP, 0, NULL, @e, 0);

      FListChannel.Add(inttostr(id));  // + 1

      ShowMsg('ͨ��ID=' + IntToStr(id)
        + ' �豸ID=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETDEVID))
        + ' ���к�=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETSERIAL))
        + ' �豸����=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETTYPE))
        + ' оƬ����=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETCHIPTYPE))
        + ' ģ��=' + GetChannelModule(0));
    end;
    // items reset
    if FListChannel.Count > 0 then begin
      FChanelId := 0;
    end;
    ShowMsg('��ʼ��ͨ���������');
    Result := true;
  end else begin
    ShowMsg('���豸ʧ��,�����豸�Ƿ��Ѿ����벢��װ������,����û�����������Ѿ����豸');
  end;
  ShowMsg('��ʼ���豸���.');
end;

function TCallManagerBase.OpenDevice(var cfg: TPhoneConfig): boolean;
begin
  FPhoneConfig := cfg;
  //
  Result := InitDevice(cfg);
end;

function TCallManagerBase.restartDevice(var cfg: TPhoneConfig): boolean;
begin
  FPhoneConfig := cfg;
  //
  CloseDevice();
  Result := InitDevice(cfg);
end;

procedure TCallManagerBase.CloseDevice();
begin
  ShowMsg('�豸�رտ�ʼ...');
  CPC_CloseDevice(ODT_ALL, 0);
  FListChannel.Clear();
  ShowMsg('�豸�رս���.');
end;

function TCallManagerBase.GetChannelModule(chid: smallint):string;
var
  lModule:longint;
  strModule:string;
begin
  lModule := CPC_DevInfo(chid, CPC_DEVINFO_GETMODULE);
  if (lModule AND DEVMODULE_DOPLAY) <> 0 then begin
    strModule := strModule + '������/';
  end;
  if (lModule AND DEVMODULE_CALLID) <> 0 then begin
    strModule := strModule + '��������ʾ/';
  end;
  if (lModule AND DEVMODULE_PHONE) <> 0 then begin
    strModule := strModule + '��������/';
  end;
  if (lModule AND DEVMODULE_SWITCH) <> 0 then begin
    strModule := strModule + '�Ͽ��绰��/';
  end;
  if (lModule AND DEVMODULE_PLAY2TEL) <> 0 then begin
    strModule := strModule + '�����������绰��/';
  end;
  if (lModule AND DEVMODULE_HOOK) <> 0 then begin
    strModule := strModule + '��ժ��/';
  end;
  if (lModule AND DEVMODULE_MICSPK) <> 0 then begin
    strModule := strModule + '�ж���/MIC/';
  end;
  if (lModule AND DEVMODULE_RING) <> 0 then begin
    strModule := strModule + 'ģ�⻰������/';
  end;
  if (lModule AND DEVMODULE_FAX) <> 0 then begin
    strModule := strModule + '�շ�����/';
  end;
  if (lModule AND DEVMODULE_POLARITY) <> 0 then begin
    strModule := strModule + '�������/';
  end;
  Result := strModule;
end;

function TCallManagerBase.getChannelS: string;
var channel: string;
begin
  if self.FListChannel.Count>0 then begin
    channel := FListChannel.Text;
  end else begin
    channel := '��';
  end;
  Result := 'ͨ��: ' + channel;
end;

procedure TCallManagerBase.tryGeneral(uGeneralType, nValue: longint; pValue: BRIPCHAR8; const msgName: string);
begin
  TGeneralCmd.tryGeneral(FChanelId, uGeneralType, nValue, pValue, msgName);
end;

function TCallManagerBase.General(uGeneralType: longint): longint;
begin
  Result := TGeneralCmd.General(FChanelId, uGeneralType);
end;

function TCallManagerBase.reloadCfg(): longint;
begin
  Result := TGeneralCmd.reloadCfg(FChanelId);
end;

{initialization
  ShowMessage('1 ini');      //��Ԫ��ʼ������
finalization
  ShowMessage('1 final');    //��Ԫ�˳�ʱ�Ĵ���
}

end.


