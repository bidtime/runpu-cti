unit uFrmSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Samples.Spin, Vcl.ExtCtrls;

type
  TfrmSetting = class(TForm)
    btnSave: TButton;
    btnReset: TButton;
    btnClose: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    edtHost: TEdit;
    spedPort: TSpinEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    cbxRecFileFormat: TComboBox;
    fileecho: TCheckBox;
    fileagc: TCheckBox;
    amGroupBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    cbxSpkAm: TComboBox;
    cbxMicAm: TComboBox;
    GroupBox5: TGroupBox;
    Label11: TLabel;
    spedUpScanInterv: TSpinEdit;
    Label12: TLabel;
    spedUpInterv: TSpinEdit;
    GroupBox6: TGroupBox;
    Label15: TLabel;
    edtUpResUrl: TEdit;
    Label13: TLabel;
    spedUpResMaxNum: TSpinEdit;
    Label16: TLabel;
    spedUpResTimeOut: TSpinEdit;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label14: TLabel;
    Label5: TLabel;
    edtUpDataUrl: TEdit;
    spedUpDataMaxNum: TSpinEdit;
    spedUpDataTimeOut: TSpinEdit;
    Label17: TLabel;
    spedUpConnTimeOut: TSpinEdit;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    edtOutPrefix: TEdit;
    edtExtNo: TEdit;
    GroupBox7: TGroupBox;
    cbxAutoCallRec: TCheckBox;
    Label1: TLabel;
    spEditValidPeriod: TSpinEdit;
    cbxCallInAutoConfirm: TCheckBox;
    cbxDialupAutoConfirm: TCheckBox;
    edtCallingNo: TEdit;
    Label20: TLabel;
    TabSheet2: TTabSheet;
    GroupBox9: TGroupBox;
    Label27: TLabel;
    spedLogMaxLines: TSpinEdit;
    Label18: TLabel;
    cbxLogLevel: TComboBox;
    GroupBox10: TGroupBox;
    Label26: TLabel;
    Label28: TLabel;
    edtUpgradeURL: TEdit;
    spedUpgradeInterv: TSpinEdit;
    TabSheet5: TTabSheet;
    GroupBox11: TGroupBox;
    cbxCtrlWatchDog: TCheckBox;
    Label23: TLabel;
    TabSheet6: TTabSheet;
    cbxAutoRun: TCheckBox;
    gbDisk: TGroupBox;
    Label25: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Bevel1: TBevel;
    LblAvailUnit1: TLabel;
    LblAvailUnit2: TLabel;
    LblFreeUnit2: TLabel;
    LblFreeUnit1: TLabel;
    lblTotalUnit1: TLabel;
    lblTotalUnit2: TLabel;
    GroupBox8: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label19: TLabel;
    spedDelRecScanInterv: TSpinEdit;
    spedDelLogInterv: TSpinEdit;
    spedDelRecInterv: TSpinEdit;
    spedDelLogScanInterv: TSpinEdit;
    GroupBox13: TGroupBox;
    Label31: TLabel;
    Label33: TLabel;
    edtBadDir: TEdit;
    edtUploadDir: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label32: TLabel;
    edtCallDir: TEdit;
    Button3: TButton;
    Label34: TLabel;
    edtFailDir: TEdit;
    Button4: TButton;
    Label35: TLabel;
    spedHangAftInterv: TSpinEdit;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    FOutPrefix: string;
    procedure ctrl2Config();
    procedure config2Ctrl();
    procedure OpenExplor(const path: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function outPrefixChg(): boolean;
  end;

implementation

uses uPhoneConfig, uLog4me, uRegUtils, uDiskUtils, uFileRecUtils, uRecInf, ShellAPI;

{$R *.dfm}

procedure TfrmSetting.btnResetClick(Sender: TObject);
begin
  if (g_PhoneConfig.resetConfig()) then begin
    MessageBox(self.Handle, 'ÅäÖÃÖØÖÃ³É¹¦', 'ÌáÊ¾', MB_OK + MB_ICONINFORMATION);
    config2Ctrl;
    ModalResult := mrOK;
  end else begin
    MessageBox(self.Handle, 'ÅäÖÃÖØÖÃÊ§°Ü', '´íÎó', MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrmSetting.btnSaveClick(Sender: TObject);
begin
  ctrl2Config;
  if (g_PhoneConfig.writeIni()) then begin
    TRegUtils.setAutoRun(cbxAutoRun.Checked);
    MessageBox(self.Handle, 'ÅäÖÃ±£´æ³É¹¦', 'ÌáÊ¾', MB_OK + MB_ICONINFORMATION);
    ModalResult := mrOK;
  end else begin
    MessageBox(self.Handle, 'ÅäÖÃ±£´æÊ§°Ü', '´íÎó', MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrmSetting.Button1Click(Sender: TObject);
begin
  OpenExplor(edtBadDir.Text);
end;

procedure TfrmSetting.Button2Click(Sender: TObject);
begin
  OpenExplor(edtUploadDir.Text);
end;

procedure TfrmSetting.Button3Click(Sender: TObject);
begin
  OpenExplor(edtCallDir.Text);
end;

procedure TfrmSetting.Button4Click(Sender: TObject);
begin
  OpenExplor(edtFailDir.Text);
end;

procedure TfrmSetting.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSetting.config2Ctrl;
  procedure setStrsIndexDef(cbx: TComboBox; const idx: integer; const defVal: integer);
  begin
    if (idx >=0) and (idx < cbx.Items.Count) then begin
      cbx.ItemIndex := idx;
    end else begin
      cbx.ItemIndex := defVal;
    end;
  end;

  function getIdxOfStr(strs: TStrings; const S: string): integer;
  var i: integer;
    tmp: string;
  begin
    Result := -1;
    for I := 0 to strs.Count - 1 do begin
      tmp := strs[I];
      if tmp.Equals(S) then begin
        Result := I;
        break;
      end;
    end;
  end;

  procedure setStrsTextIdxDef(cbx: TComboBox; const S: string; const defIdx: integer);
  var i: integer;
  begin
    i := getIdxOfStr(cbx.Items, S);
    if (i>=0) and (i<cbx.Items.Count - 1) then begin
      cbx.itemIndex := i;
    end else begin
      cbx.itemIndex := defIdx;
    end;
  end;

  procedure setStrsTextIdx(cbx: TComboBox; const S: string);
  begin
    setStrsTextIdxDef(cbx, S, 0);
  end;

  procedure setStrsIndex(cbx: TComboBox; const idx: integer);
  begin
    setStrsIndexDef(cbx, idx, 0);
  end;

begin
  setStrsIndex(self.cbxRecFileFormat, g_PhoneConfig.RecFileFormat);
  self.FileEcho.Checked := g_PhoneConfig.FileEcho;
  self.FileAgc.Checked := g_PhoneConfig.FileAgc;
  //
  setStrsIndex(self.cbxSpkAM, g_PhoneConfig.SpkAM);
  setStrsIndex(self.cbxMicAM, g_PhoneConfig.MicAM);
  //
  self.cbxAutoCallRec.Checked := g_PhoneConfig.AutoCallRec;
  self.spEditValidPeriod.Value := g_PhoneConfig.ValidCallPeriod;
  //
  self.cbxCallInAutoConfirm.Checked := g_PhoneConfig.CallInAutoConfirm;
  self.cbxDialUpAutoConfirm.Checked := g_PhoneConfig.DialUpAutoConfirm;
  //
  self.edtHost.Text := g_PhoneConfig.Host;
  self.spedPort.Value := g_PhoneConfig.Port;
  //
  self.edtUpResUrl.Text := g_PhoneConfig.UpResUrl;
  self.spedUpResTimeOut.Value := g_PhoneConfig.UpResTimeOut;
  self.spedUpResMaxNum.Value := g_PhoneConfig.UpResMaxNum;
  //
  self.edtUpDataUrl.Text := g_PhoneConfig.UpDataUrl;
  self.spedUpDataTimeOut.Value := g_PhoneConfig.UpDataTimeOut;
  self.spedUpDataMaxNum.Value := g_PhoneConfig.UpDataMaxNum;
  self.spedUpConnTimeOut.Value := g_PhoneConfig.UpConnTimeOut;
  self.spedHangAftInterv.Value := g_PhoneConfig.hangAftInterv;
  //
  self.spedUpScanInterv.Value := g_PhoneConfig.UpScanInterv;
  self.spedUpInterv.Value := g_PhoneConfig.UpInterv;
  //
  self.spedDelRecScanInterv.Value := g_PhoneConfig.DelRecScanInterv;
  self.spedDelRecInterv.Value := g_PhoneConfig.DelRecInterv;
  //
  self.spedDelLogScanInterv.Value := g_PhoneConfig.DelLogScanInterv;
  self.spedDelLogInterv.Value := g_PhoneConfig.DelLogInterv;
  //
  self.edtUpgradeURL.Text := g_PhoneConfig.upgradeURL;
  self.spedUpgradeInterv.Value := g_PhoneConfig.upgradeInterv;
  self.spedLogMaxLines.value := g_PhoneConfig.LogMaxLines;
  self.cbxCtrlWatchDog.Checked := g_PhoneConfig.ctrlWatchDog;
  //
  self.edtOutPrefix.Text := g_PhoneConfig.OutPrefix;
  self.edtCallingNo.Text := g_PhoneConfig.CallingNo;
  self.edtExtNo.Text := g_PhoneConfig.ExtNo;
  //
  self.cbxAutoRun.Checked := TRegUtils.isAutoRun;
  //
  setStrsTextIdx(self.cbxLogLevel, getLogLevel());
end;

procedure TfrmSetting.ctrl2Config;
begin
  g_PhoneConfig.RecFileFormat := self.cbxRecFileFormat.ItemIndex;
  g_PhoneConfig.FileEcho := self.FileEcho.Checked;
  g_PhoneConfig.FileAgc := self.FileAgc.Checked;
  //
  g_PhoneConfig.SpkAM := self.cbxSpkAM.ItemIndex;
  g_PhoneConfig.MicAM := self.cbxMicAM.ItemIndex;
  //
  g_PhoneConfig.AutoCallRec := self.cbxAutoCallRec.Checked;
  g_PhoneConfig.ValidCallPeriod := self.spEditValidPeriod.Value;
  //
  g_PhoneConfig.CallInAutoConfirm := self.cbxCallInAutoConfirm.Checked;
  g_PhoneConfig.DialUpAutoConfirm := self.cbxDialUpAutoConfirm.Checked;
  //
  g_PhoneConfig.Host := self.edtHost.Text;
  g_PhoneConfig.Port := self.spedPort.Value;
  //
  g_PhoneConfig.UpResUrl := self.edtUpResUrl.Text;
  g_PhoneConfig.UpResTimeOut := self.spedUpResTimeOut.Value;
  g_PhoneConfig.UpResMaxNum := self.spedUpResMaxNum.Value;
  //
  g_PhoneConfig.UpDataUrl := self.edtUpDataUrl.Text;
  g_PhoneConfig.UpDataTimeOut := self.spedUpDataTimeOut.Value;
  g_PhoneConfig.UpDataMaxNum := self.spedUpDataMaxNum.Value;
  g_PhoneConfig.UpConnTimeOut := self.spedUpConnTimeOut.Value;
  g_PhoneConfig.hangAftInterv := self.spedHangAftInterv.Value;
  //
  g_PhoneConfig.UpScanInterv := self.spedUpScanInterv.Value;
  g_PhoneConfig.UpInterv := self.spedUpInterv.Value;
  //
  g_PhoneConfig.DelRecScanInterv := self.spedDelRecScanInterv.Value;
  g_PhoneConfig.DelRecInterv := self.spedDelRecInterv.Value;
  //
  g_PhoneConfig.DelLogScanInterv := self.spedDelLogScanInterv.Value;
  g_PhoneConfig.DelLogInterv := self.spedDelLogInterv.Value;
  //
  g_PhoneConfig.upgradeURL := self.edtUpgradeURL.Text;
  g_PhoneConfig.upgradeInterv := self.spedUpgradeInterv.Value;
  g_PhoneConfig.LogMaxLines := self.spedLogMaxLines.value;
  //
  g_PhoneConfig.ctrlWatchDog := self.cbxCtrlWatchDog.Checked;
  //
  g_PhoneConfig.OutPrefix := self.edtOutPrefix.Text;
  g_PhoneConfig.CallingNo := self.edtCallingNo.Text;
  g_PhoneConfig.ExtNo := self.edtExtNo.Text;
  //
  setLogLevel(self.cbxLogLevel.Text);
end;

constructor TfrmSetting.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  self.PageControl1.ActivePageIndex := 0;
end;

destructor TfrmSetting.Destroy;
begin
  inherited;
end;

procedure TfrmSetting.FormCreate(Sender: TObject);
var i: integer;
begin
  // doplaymux
  {doplaymux.Clear();
  doplaymux.Items.Add('²¥·ÅµÄÓïÒôµ½À®°È');
  doplaymux.Items.Add('ÏßÂ·ÓïÒôµ½À®°È');
  doplaymux.ItemIndex := 0;}

  for i:=0 to 15 do begin
    cbxSpkam.Items.Add(InttoStr(i));
  end;

  for i:=0 to 7 do begin
    cbxMicam.Items.Add(InttoStr(i));
  end;

  // recfileformat
  cbxRecFileFormat.Clear();
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_DEFAULT (BRI_AUDIO_FORMAT_PCM8K16B)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_ALAW8K (8k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_ULAW8K (8k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_IMAADPCM8K4B (4k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_PCM8K8B (8k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_PCM8K16B (16k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_MP38K8B (1.2k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_MP38K16B( 2.4k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_TM8K1B (1.5k/s)');
  cbxRecFileFormat.Items.Add('BRI_WAV_FORMAT_GSM6108K(2.2k/s)');
  cbxRecFileFormat.ItemIndex := 0;
  //
  self.edtBadDir.text := TFileRecUtils.getDirOfRec(TRecInf.BAD);
  self.edtUploadDir.text := TFileRecUtils.getDirOfRec(TRecInf.UPLOAD);
  self.edtCallDir.text := TFileRecUtils.getDirOfRec(TRecInf.CALL);
  self.edtFailDir.text := TFileRecUtils.getDirOfRec(TRecInf.BAD);
end;

procedure TfrmSetting.FormShow(Sender: TObject);
  procedure showDiskInfo();
  var diskInf: TDiskInf;
  begin
    diskInf.fit;
    //
    gbDisk.Caption := diskInf.fmtDiskLabel();
    //
    self.LblAvailUnit1.Caption := diskInf.FAvailU.fmtByte;
    self.LblAvailUnit2.Caption := diskInf.FAvailU.fmtGB;
    //
    self.LblFreeUnit1.Caption := diskInf.FFreeU.fmtByte;
    self.LblFreeUnit2.Caption := diskInf.FFreeU.fmtGB;
    //
    self.LblTotalUnit1.Caption := diskInf.FTotalU.fmtByte;
    self.LblTotalUnit2.Caption := diskInf.FTotalU.fmtGB;
  end;
begin
  config2Ctrl();
  FOutPrefix := g_PhoneConfig.OutPrefix;
  //
  showDiskInfo();
end;

function TfrmSetting.outPrefixChg: boolean;
begin
  Result := FOutPrefix.Equals(g_PhoneConfig.OutPrefix);
end;

procedure TfrmSetting.OpenExplor(const path: string);
begin
  //ShellExecute(self.Handle, 'open', PChar('explorer.exe'), PChar('/select,' + path), nil, SW_NORMAL);
  ShellExecute(self.Handle, 'open', PChar('explorer.exe'), PChar('/open,' + path), nil, SW_NORMAL);
end;

end.
