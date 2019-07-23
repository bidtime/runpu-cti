unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  brisdklib, uCallManager, uFrmSetting, Vcl.Tabs;

type
  TfrmMain = class(TForm)
    GroupBox1: TGroupBox;
    dohook: TCheckBox;
    dophone: TCheckBox;
    linetospk: TCheckBox;
    playtospk: TCheckBox;
    mictoline: TCheckBox;
    memoMsg: TMemo;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    dialcode: TLabel;
    channellist: TComboBox;
    pstncode: TEdit;
    dial: TButton;
    refusecallin: TButton;
    btnSetParam: TButton;
    procedure dialClick(Sender: TObject);
    procedure dohookClick(Sender: TObject);
    procedure dophoneClick(Sender: TObject);
    procedure refusecallinClick(Sender: TObject);
    procedure btnSetParamClick(Sender: TObject);
  private
    FCallManager: TCallManager;
    frmSetting: TfrmSetting;
    { Private declarations }
    procedure ShowSysMsg(const msg : String); overload;
    procedure ShowMsg(const msg : String); overload;
    procedure openDevice;
    procedure closeDevice;
  protected
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses uFormatMsg;

{$R *.dfm}

//procedure TFrmSocketServer.showLogs(const S: string; const clear:boolean);
//begin
//  //show response (threadsafe)
//  TThread.Synchronize(nil,
//    procedure
//    begin
//      self.Memo1.Lines.Insert(0, S);
//    end);
//end;

procedure TfrmMain.ShowMsg(const msg : String);
  procedure insertLog(const msg : String);
  begin
    TThread.Synchronize(nil,
      procedure
      begin
        self.memoMsg.Lines.Insert(0, msg);
      end);
  end;
begin
  insertLog(msg);
  Application.ProcessMessages;
  Sleep(0);
end;

procedure TfrmMain.ShowSysMsg(const msg : String);
begin
  ShowMsg( TFormatMsg.getMsgSys(msg) );
end;

procedure TfrmMain.btnSetParamClick(Sender: TObject);
begin
  frmSetting.ShowModal;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  frmSetting := TfrmSetting.Create(self);
  FCallManager := TCallManager.Create(self.Handle);
  FCallManager.OnShowLogs := ShowMsg;
  //
  memoMsg.Clear;
  ShowSysMsg('系统开始启动...');
  //
  OpenDevice();
  //
  ShowSysMsg('系统启动结束.');
end;

destructor TfrmMain.Destroy;
begin
  CloseDevice();
  FCallManager.Free;
  frmSetting.Free;
  inherited;
end;

procedure TfrmMain.MyMsgProc(var Msg: TMessage);
begin
  self.FCallManager.MyMsgProc(Msg);
end;

procedure TfrmMain.dialClick(Sender: TObject);
begin
  try
    self.FCallManager.dialup(pstncode.Text);
  except
    on e: Exception do begin
      MessageBox(handle, PChar(e.Message), '错误', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.refusecallinClick(Sender: TObject);
begin
  try
    self.FCallManager.refuseCallIn();
  except
    on e: Exception do begin
      MessageBox(handle, PChar(e.Message), '错误', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.dohookClick(Sender: TObject);
begin
  FCallManager.hookup(dohook.Checked);
end;

procedure TfrmMain.dophoneClick(Sender: TObject);
begin
  FCallManager.hangup(NOT dophone.Checked);
end;

procedure TfrmMain.openDevice();
begin
  self.FCallManager.OpenDevice(self.frmSetting.PhoneConfig);
  self.channellist.Items.Assign(FCallManager.ListChannel);
  if channellist.Items.Count > 0 then begin
    channellist.ItemIndex := 0;
  end;
end;

procedure TfrmMain.closeDevice();
begin
  self.FCallManager.CloseDevice;
end;

end.
