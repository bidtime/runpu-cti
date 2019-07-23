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

//初始化设备
function TCallManagerBase.InitDevice(var cfg: TPhoneConfig): boolean;

var //e:TBriEvent_Data;
  id:BRIINT16;
begin
  Result := false;
  ShowMsg('初始化设备开始...');
  resetVal();
  if CPC_OpenDevice(0, 0, NULL) > 0 then begin
    FDevType := CPC_DevInfo(0, CPC_DEVINFO_GETTYPE);
    FDevChanls := CPC_DevInfo(0, CPC_DEVINFO_GETCHANNELS);
    ShowMsg('初始化设备成功,总共通道：' + IntToStr(FDevChanls));
    // for
    for id := 0 to ( FDevChanls - 1 ) do begin
      //建议软件测试时建议关闭看门狗,正式发布时开启看门狗
      //如果测试软件不关闭看门狗,在程序断点停留超过5秒,设备将被自动复位,就需要重新打开设备了
      if g_phoneConfig.ctrlWatchDog then begin
        ShowMsg('自动复位开关: ' + '开启');
        CPC_SetDevCtrl(id, CPC_CTRL_WATCHDOG, 1);   // 0/1：关闭/打开设备看门狗
      end else begin
        ShowMsg('自动复位开关: ' + '关闭');
        CPC_SetDevCtrl(id, CPC_CTRL_WATCHDOG, 0);   // 0/1：关闭/打开设备看门狗
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

      ShowMsg('通道ID=' + IntToStr(id)
        + ' 设备ID=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETDEVID))
        + ' 序列号=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETSERIAL))
        + ' 设备类型=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETTYPE))
        + ' 芯片类型=' + IntToStr(CPC_DevInfo(id, CPC_DEVINFO_GETCHIPTYPE))
        + ' 模块=' + GetChannelModule(0));
    end;
    // items reset
    if FListChannel.Count > 0 then begin
      FChanelId := 0;
    end;
    ShowMsg('初始化通道参数完成');
    Result := true;
  end else begin
    ShowMsg('打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备');
  end;
  ShowMsg('初始化设备完成.');
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
  ShowMsg('设备关闭开始...');
  CPC_CloseDevice(ODT_ALL, 0);
  FListChannel.Clear();
  ShowMsg('设备关闭结束.');
end;

function TCallManagerBase.GetChannelModule(chid: smallint):string;
var
  lModule:longint;
  strModule:string;
begin
  lModule := CPC_DevInfo(chid, CPC_DEVINFO_GETMODULE);
  if (lModule AND DEVMODULE_DOPLAY) <> 0 then begin
    strModule := strModule + '有喇叭/';
  end;
  if (lModule AND DEVMODULE_CALLID) <> 0 then begin
    strModule := strModule + '有来电显示/';
  end;
  if (lModule AND DEVMODULE_PHONE) <> 0 then begin
    strModule := strModule + '话机拨号/';
  end;
  if (lModule AND DEVMODULE_SWITCH) <> 0 then begin
    strModule := strModule + '断开电话机/';
  end;
  if (lModule AND DEVMODULE_PLAY2TEL) <> 0 then begin
    strModule := strModule + '播放语音到电话机/';
  end;
  if (lModule AND DEVMODULE_HOOK) <> 0 then begin
    strModule := strModule + '软摘机/';
  end;
  if (lModule AND DEVMODULE_MICSPK) <> 0 then begin
    strModule := strModule + '有耳机/MIC/';
  end;
  if (lModule AND DEVMODULE_RING) <> 0 then begin
    strModule := strModule + '模拟话机震铃/';
  end;
  if (lModule AND DEVMODULE_FAX) <> 0 then begin
    strModule := strModule + '收发传真/';
  end;
  if (lModule AND DEVMODULE_POLARITY) <> 0 then begin
    strModule := strModule + '反级检测/';
  end;
  Result := strModule;
end;

function TCallManagerBase.getChannelS: string;
var channel: string;
begin
  if self.FListChannel.Count>0 then begin
    channel := FListChannel.Text;
  end else begin
    channel := '无';
  end;
  Result := '通道: ' + channel;
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
  ShowMessage('1 ini');      //单元初始化代码
finalization
  ShowMessage('1 final');    //单元退出时的代码
}

end.


