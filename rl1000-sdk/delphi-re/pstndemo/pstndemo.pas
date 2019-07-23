unit pstndemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,brisdklib, StdCtrls, channeldata;

type
  TForm1 = class(TForm)
    opendev: TButton;
    closedev: TButton;
    btnStartDial: TButton;
    playfile: TButton;
    GroupBox1: TGroupBox;
    dophone: TCheckBox;
    linetospk: TCheckBox;
    playtospk: TCheckBox;
    mictoline: TCheckBox;
    opendoplay: TCheckBox;
    recfile: TButton;
    Label1: TLabel;
    channellist: TComboBox;
    refusecallin: TButton;
    startflash: TButton;
    dialcode: TLabel;
    pstncode: TEdit;
    doplaymux: TComboBox;
    playfiledialog: TOpenDialog;
    stopplayfile: TButton;
    stoprecfile: TButton;
    recfiledialog: TSaveDialog;
    fileecho: TCheckBox;
    fileagc: TCheckBox;
    Label2: TLabel;
    recfileformat: TComboBox;
    amGroupBox: TGroupBox;
    Label3: TLabel;
    spkam: TComboBox;
    Label4: TLabel;
    micam: TComboBox;
    startspeech: TButton;
    Button2: TButton;
    btnStopDial: TButton;
    memoLog: TMemo;
    btnDoPhone: TButton;
    btnDoHook: TButton;
    dohook: TCheckBox;
    btnClearLog: TButton;
    procedure closedevClick(Sender: TObject);
    procedure InitDevice();
    procedure opendevClick(Sender: TObject);
    procedure ProcDevErr(lerrid : longint);
    procedure StopchannelPlayfile(chid: Smallint);
    procedure StopchannelRecfile(chid: Smallint);
    function  GetChannelModule(chid:smallint):string;
    procedure linetospkClick(Sender: TObject);
    procedure playtospkClick(Sender: TObject);
    procedure mictolineClick(Sender: TObject);
    procedure opendoplayClick(Sender: TObject);
    procedure btnStartDialClick(Sender: TObject);
    procedure doplaymuxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure playfileClick(Sender: TObject);
    procedure stopplayfileClick(Sender: TObject);
    procedure recfileClick(Sender: TObject);
    procedure refusecallinClick(Sender: TObject);
    procedure startflashClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure spkamChange(Sender: TObject);
    procedure micamChange(Sender: TObject);
    procedure stoprecfileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure startspeechClick(Sender: TObject);
    procedure btnStopDialClick(Sender: TObject);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure btnDoHookClick(Sender: TObject);
    procedure btnDoPhoneClick(Sender: TObject);
    procedure btnClearLogClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowMsg(const msg : WideString); overload;
    procedure ShowMsg(const chanelId: smallInt; const msg : WideString); overload;
    procedure MyMsgProcIt(const evData: TBriEvent_Data);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uEventTypeMap, uChannelCmd;

{$R *.dfm}

procedure TForm1.ShowMsg(const msg : WideString);
begin
  self.memoLog.Lines.Insert(0, msg);
end;

procedure TForm1.ShowMsg(const chanelId: smallInt; const msg : WideString);
begin
  ShowMsg('ͨ��' + IntToStr(chanelId) + ': ' + msg);
end;

procedure TForm1.ProcDevErr(lerrid : longint);
begin
  case lerrid of
    0: begin
      ShowMsg('��ȡ���ݴ���');
    end;
    1: begin
      ShowMsg('д�����ݴ���');
    end;
    2: begin
      ShowMsg('����֡ID��ʧ,������CPU̫æ');
    end;
    3: begin
      ShowMsg('�豸�Ѿ����ε�');
    end;
    4: begin
      ShowMsg('���кų�ͻ');
    end;
    else begin
      ShowMsg('δ֪����');
    end;
  end;
end;

procedure TForm1.StopchannelRecfile(chid: Smallint);
begin
	if ChannelStatus[chid].lRecFileID > 0 then begin
  	CPC_RecordFile(chid,CPC_RECORD_FILE_STOP,ChannelStatus[chid].lRecFileID,0,NULL);
		ChannelStatus[chid].lRecFileID := -1;
    ShowMsg(chid, 'ֹͣ�ļ�¼��');
	end;
end;

procedure TForm1.StopChannelPlayfile(chid: Smallint);
begin
	if ChannelStatus[chid].lPlayFileID > 0 then begin
  	CPC_PlayFile(chid,CPC_PLAY_FILE_STOP,ChannelStatus[chid].lPlayFileID,0,NULL);
		ChannelStatus[chid].lPlayFileID := -1;
    ShowMsg(chid, 'ֹͣ����');
	end;
end;

//��Ϣ�¼�������
procedure TForm1.MyMsgProc(var Msg:TMessage);
var
  pEvent: PTBriEvent_Data;
  //e: TBriEvent_Data;
begin
  pEvent := PTBriEvent_Data(Msg.LParam);
  MyMsgProcIt(pEvent^);
  //CPC_Event(chnId,  CPC_EVENT_POP, 0, NULL, @e, 0);//��ʾ������ȡ�¼�������ʽ,��ʵ������
end;

//��Ϣ�¼�������
procedure TForm1.MyMsgProcIt(const evData: TBriEvent_Data);

  function toStr(a: Array of BRICHAR8): string;
  var i: integer;
    c: BRICHAR8;
  begin
    Result := '';
    for I := 0 to Length(a) do begin
      c := a[i];
      if c=#0 then begin
        break;
      end else begin
        Result := Result + c;
      end;
    end;
  end;

var
  chnId: BRIINT16;
begin
  chnId := evData.uChnId;
  ShowMsg(chnId, 'first,' + TChannelCmd.fmtEvent(evData));
  // case
  case evData.lEventType of
    BriEvent_PhoneHook: begin
      ShowMsg(chnId,  '���ػ���ժ��');
      if CPC_General(chnId, CPC_GENERAL_ISDIALING, 0, NULL) = 0 then begin
        CPC_SetDevCtrl(chnId, CPC_CTRL_DOHOOK, 0);
        ShowMsg(chnId,  '�Զ���һ�����ֹ��������豸��������ͨ��');
      end;
    end;
    BriEvent_PhoneHang: begin
      ShowMsg(chnId, '���ػ����һ�');
    end;
    BriEvent_CallIn: begin
      if evData.szData[1] = '0' then begin
        ShowMsg(chnId, '�������忪ʼ');
      end else begin
        ShowMsg(chnId, '�������徲��');
      end;
    end;
    BriEvent_SpeechResult: begin
      ShowMsg(chnId,  '����ʶ����:' + toStr(evData.szData));
      CPC_Speech(chnId,  CPC_SPEECH_STARTSPEECH, 0, NULL);
      ShowMsg('���¿�ʼʶ��');
    end;
    BriEvent_GetCallID: begin
      ShowMsg(chnId, '��ȡ��������� ' + evData.szData);
    end;
    BriEvent_StopCallIn: begin
      ShowMsg(chnId,  '�Է�ֹͣ�������һ��δ�ӵ绰 ');
    end;
    BriEvent_DialEnd: begin
      ShowMsg(chnId, '���Ž���');
      if CPC_GetDevCtrl(chnId, CPC_CTRL_PHONE) > 0 then begin
        CPC_SetDevCtrl(chnId, CPC_CTRL_DOHOOK, 0);
        ShowMsg(chnId, '��⵽�绰����ժ��,�Զ���һ�����ֹ��������豸����3��ͨ��');
      end;
    end;
    BriEvent_PlayFileEnd: begin
      ShowMsg(chnId, '�����ļ�����');
    end;
    BriEvent_PlayMultiFileEnd: begin
      ShowMsg(chnId, '���ļ���������');
    end;
    BriEvent_GetDTMFChar: begin
      ShowMsg(chnId, '��⵽DTMF����:' + evData.szData);
    end;
    BriEvent_Busy: begin
      ShowMsg(chnId, '��⵽æ���ź�/����δͨ����ͨ���ѽ���');
    end;
    BriEvent_RemoteHook: begin
      ShowMsg(chnId, '��⵽�Է�ժ��');
    end;
    BriEvent_RemoteHang: begin
      ShowMsg(chnId, '��⵽�Է��һ�');
    end;
    BriEvent_DialTone: begin
      ShowMsg(chnId, '��⵽������');
    end;
    BriEvent_PhoneDial: begin
      ShowMsg(chnId, '���ػ�������:' + evData.szData);
    end;
    BriEvent_RingBack: begin
      ShowMsg(chnId, '��⵽������');
    end;
    BriEvent_RefuseEnd: begin
      ShowMsg(chnId, '�ܽ����');
    end;
    BriEvent_FlashEnd: begin
     ShowMsg(chnId, '�Ĳ�����');
    end;
    BriEvent_PSTNFree: begin
      ShowMsg(chnId, 'call log reset, �豸����.');
    end;
    BriEvent_CallLog: begin
      ShowMsg(chnId, 'call log success, lResult=' + IntToStr(evData.lResult));
      TCallLogCmd.resetCall(chnId);
    end;
    BriEvent_EnableHook: begin
      ShowMsg(chnId, 'EnableHook, lResult=' + IntToStr(evData.lResult));
    end;
    BriEvent_DevErr: begin
      ProcDevErr(evData.lResult);
    end;
    //else begin
      //ShowMsg(chnId, '�����¼� id='+IntToStr(evData.lEventType) + ' result=' +IntToStr(evData.lResult));
    //end;
  end;
  //ShowMsg(chnId, '  last,' + TChannelCmd.fmtEvent(evData));
end;

procedure TForm1.closedevClick(Sender: TObject);
begin
  CPC_CloseDevice(ODT_ALL,0);
  channellist.Clear();
  ShowMsg('�豸�ѹر�');
end;

function  TForm1.GetChannelModule(chid:smallint):string;
var
  lModule:longint;
  strModule:string;
begin
  lModule := CPC_DevInfo(chid,CPC_DEVINFO_GETMODULE);
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

//��ʼ���豸
procedure TForm1.InitDevice();
var
  id: integer;
  //e: TBriEvent_Data;
begin
  channellist.Clear();
  if CPC_OpenDevice(0,0,NULL)> 0 then begin
    ShowMsg('��ʼ���豸�ɹ�,�ܹ�ͨ����'+IntToStr(CPC_DevInfo(0,CPC_DEVINFO_GETCHANNELS)));
    // for
    for id:=0 to CPC_DevInfo(0,CPC_DEVINFO_GETCHANNELS)-1 do begin
      //�����������ʱ����رտ��Ź�,��ʽ����ʱ�������Ź�
      //�������������رտ��Ź�,�ڳ���ϵ�ͣ������5��,�豸�����Զ���λ,����Ҫ���´��豸��
      CPC_SetDevCtrl(id, CPC_CTRL_WATCHDOG, 0);
      //
      micam.ItemIndex := CPC_GetParam(id,CPC_PARAM_AM_MIC);
	    spkam.itemindex := CPC_GetParam(id,CPC_PARAM_AM_SPKOUT);
      ChannelStatus[id].lRecFileID  := -1;
      ChannelStatus[id].lPlayFileID := -1;
      CPC_Event(id,CPC_EVENT_REGWND,handle,NULL,NULL,0);
      //CPC_Event(id, CPC_EVENT_POP, 0, NULL, @e, 0);

      channellist.Items.Add('ͨ��'+inttostr(id+1));

      ShowMsg(id,
          ' �豸ID=' + IntToStr(CPC_DevInfo(id,CPC_DEVINFO_GETDEVID))
        + ' ���к�=' + IntToStr(CPC_DevInfo(id,CPC_DEVINFO_GETSERIAL))
        + ' �豸����=' + IntToStr(CPC_DevInfo(id,CPC_DEVINFO_GETTYPE))
        + ' оƬ����=' + IntToStr(CPC_DevInfo(id,CPC_DEVINFO_GETCHIPTYPE))
        + ' ģ��=' + GetChannelModule(0));
    end;
    // items reset
    if channellist.Items.Count > 0 then begin
      channellist.ItemIndex := 0;
    end;
    ShowMsg('��ʼ��ͨ���������');
  end else begin
    ShowMsg('���豸ʧ��,�����豸�Ƿ��Ѿ����벢��װ������,����û�����������Ѿ����豸');
  end;
end;

procedure TForm1.opendevClick(Sender: TObject);
begin
  CPC_CloseDevice(ODT_ALL, 0);
  InitDevice();
end;

procedure TForm1.linetospkClick(Sender: TObject);
begin
  CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOLINETOSPK, Integer(linetospk.Checked));
end;

procedure TForm1.playtospkClick(Sender: TObject);
begin
  CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOPLAYTOSPK, Integer(playtospk.Checked));
end;

procedure TForm1.mictolineClick(Sender: TObject);
begin
  CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOMICTOLINE, Integer(mictoline.Checked));
end;

procedure TForm1.opendoplayClick(Sender: TObject);
begin
  CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOPLAY, Integer(opendoplay.Checked));
end;

procedure TForm1.btnStartDialClick(Sender: TObject);
begin
  if pstncode.Text = '' then begin
    MessageBox(handle, '���������,һ�����ſ����ӳ�1��', '����', MB_OK);
  end else begin
    CPC_General(channellist.ItemIndex,CPC_GENERAL_STARTDIAL,0,BRIPCHAR8(AnsiString(pstncode.Text)));
  end;
end;

procedure TForm1.doplaymuxChange(Sender: TObject);
begin
  case doplaymux.ItemIndex of
    0: begin
      CPC_SetDevCtrl(channellist.ItemIndex ,CPC_CTRL_PLAYMUX, DOPLAY_CHANNEL0_DAC);//ѡ������·����
    end;
    1: begin
      CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_PLAYMUX, DOPLAY_CHANNEL0_ADC);//ѡ������·����
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  id : integer;
begin
  //SendMessage(lbmsg.Handle, LB_SETHORIZONTALEXTENT, 1024, 0);
  self.memoLog.Clear;
  // doplaymux
  doplaymux.Clear();
  doplaymux.Items.Add('���ŵ�����������');
  doplaymux.Items.Add('��·����������');
  doplaymux.ItemIndex := 0;

  for id:=0 to 15 do begin
    spkam.Items.Add(InttoStr(id));
  end;

  for id:=0 to 7 do begin
    micam.Items.Add(InttoStr(id));
  end;

  // recfileformat
  recfileformat.Clear();
  recfileformat.Items.Add('BRI_WAV_FORMAT_DEFAULT (BRI_AUDIO_FORMAT_PCM8K16B)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_ALAW8K (8k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_ULAW8K (8k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_IMAADPCM8K4B (4k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_PCM8K8B (8k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_PCM8K16B (16k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_MP38K8B (1.2k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_MP38K16B( 2.4k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_TM8K1B (1.5k/s)');
  recfileformat.Items.Add('BRI_WAV_FORMAT_GSM6108K(2.2k/s)');
  recfileformat.ItemIndex := 0;
end;

procedure TForm1.playfileClick(Sender: TObject);
var
lMask : longint;
begin
  if playfiledialog.Execute then begin
    StopchannelPlayfile(channellist.ItemIndex);
    lMask := PLAYFILE_MASK_REPEAT;  //ѭ������
    ChannelStatus[channellist.ItemIndex].lPlayFileID :=
      CPC_PlayFile(channellist.ItemIndex, CPC_PLAY_FILE_START,0,lMask,
        BRIPCHAR8(AnsiString(playfiledialog.FileName)));
    if ChannelStatus[channellist.ItemIndex].lPlayFileID < 0 then begin
      ShowMsg(channellist.ItemIndex, '�����ļ�����');
    end else begin
      ShowMsg(channellist.ItemIndex, '��ʼ�����ļ�');
    end;
  end;
end;

procedure TForm1.stopplayfileClick(Sender: TObject);
begin
  StopchannelPlayfile(channellist.ItemIndex);
end;

procedure TForm1.recfileClick(Sender: TObject);
var
  lMask: longint;
  lFormat: longint;
begin
  if recfiledialog.Execute then begin
    StopchannelRecfile(channellist.ItemIndex);
    lMask := 0;  //RECORD_MASK_ECHO | RECORD_MASK_AGC
    if Integer(fileecho.Checked) > 0 then begin
      lMask := (lMask OR RECORD_MASK_ECHO);
    end;

    if Integer(fileagc.Checked) > 0 then begin
      lMask := (lMask OR RECORD_MASK_AGC);
    end;

    lFormat := recfileformat.ItemIndex;
    ChannelStatus[channellist.ItemIndex].lRecFileID :=
      CPC_RecordFile(channellist.ItemIndex, CPC_RECORD_FILE_START, lFormat,
        lMask, BRIPCHAR8(AnsiString(recfiledialog.FileName)));
    if ChannelStatus[channellist.ItemIndex].lRecFileID <= 0 then begin
      ShowMsg(channellist.ItemIndex, '�ļ�¼������');
    end else begin
      ShowMsg(channellist.ItemIndex, '��ʼ�ļ�¼��');
    end;
  end;
end;

procedure TForm1.refusecallinClick(Sender: TObject);
begin
  if CPC_GetDevCtrl(channellist.ItemIndex,CPC_CTRL_RINGTIMES) <= 0 then begin
	  MessageBox(handle,'û�����磬��Ч�ľܽ�','����',MB_OK);
  end else begin
    CPC_General(channellist.ItemIndex, CPC_GENERAL_STARTREFUSE, 0, NULL);
  end;
end;

procedure TForm1.startflashClick(Sender: TObject);
begin
	if (CPC_GetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOHOOK) <= 0)
      AND (CPC_GetDevCtrl(channellist.ItemIndex, CPC_CTRL_PHONE) <= 0) then begin
		MessageBox(handle,'û��ժ��״̬/PSTN����״̬����Ч���Ĳ��','����',MB_OK);
  end else begin
		if CPC_General(channellist.ItemIndex, CPC_GENERAL_STARTFLASH,
        FT_ALL,'') <= 0 then begin //*1099*/
  	  MessageBox(handle,'�Ĳ��ʧ��','ʧ��',MB_OK);
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CPC_CloseDevice(ODT_ALL,0);
end;

procedure TForm1.spkamChange(Sender: TObject);
begin
  CPC_SetParam(channellist.ItemIndex,CPC_PARAM_AM_SPKOUT,spkam.ItemIndex);
end;

procedure TForm1.micamChange(Sender: TObject);
begin
  CPC_SetParam(channellist.ItemIndex,CPC_PARAM_AM_MIC,micam.ItemIndex);
end;

procedure TForm1.stoprecfileClick(Sender: TObject);
begin
  StopchannelRecfile(channellist.ItemIndex);
end;

procedure TForm1.btnStopDialClick(Sender: TObject);
begin
  CPC_General(channellist.ItemIndex,CPC_GENERAL_STOPDIAL,0, NULL);
end;

procedure TForm1.btnDoPhoneClick(Sender: TObject);
begin
  CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOPHONE, Integer(dophone.Checked));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CPC_Speech(1,CPC_SPEECH_STOPSPEECH,0,NULL);
  CPC_SetDevCtrl(1,CPC_CTRL_DOPHONE,1);
end;

procedure TForm1.btnClearLogClick(Sender: TObject);
begin
  self.memoLog.Clear;
end;

procedure TForm1.btnDoHookClick(Sender: TObject);
begin
  CPC_SetDevCtrl(channellist.ItemIndex, CPC_CTRL_DOHOOK, Integer(dohook.Checked));
end;

procedure TForm1.startspeechClick(Sender: TObject);
begin
	CPC_SetDevCtrl(1,CPC_CTRL_DOPHONE,0);
	CPC_Speech(1,CPC_SPEECH_CONTENTLIST,0,'��,һ,��,��,��,��,��,��,��,��');
	if(CPC_Speech(1,CPC_SPEECH_STARTSPEECH,0,NULL) <= 0)  then begin
    ShowMsg('��������ʶ��ʧ��');
  end else begin
    ShowMsg('��ʼ����˵��ʶ������0-9�������𻰻�˵');
  end;
end;

end.
