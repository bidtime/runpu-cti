unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, System.Actions, Vcl.ActnList,
  Vcl.Menus, Vcl.StdActns, uFrameProp, brisdklib, uAppConst, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    actnStart: TAction;
    actnEnd: TAction;
    actnClear: TAction;
    menuFile: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    S1: TMenuItem;
    T1: TMenuItem;
    C1: TMenuItem;
    N1: TMenuItem;
    menuExit: TMenuItem;
    FileExit1: TFileExit;
    actnSetting: TAction;
    actnSetting1: TMenuItem;
    actnAbout: TAction;
    N2: TMenuItem;
    PopupMenu: TPopupMenu;
    miProperties: TMenuItem;
    MenuItem1: TMenuItem;
    miClose: TMenuItem;
    TrayIcon1: TTrayIcon;
    procedure actnEndExecute(Sender: TObject);
    procedure actnStartExecute(Sender: TObject);
    procedure actnStartUpdate(Sender: TObject);
    procedure actnEndUpdate(Sender: TObject);
    procedure actnClearExecute(Sender: TObject);
    procedure actnSettingExecute(Sender: TObject);
    procedure actnAboutExecute(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    //FTaskMessage: DWord;
    FClosing: Boolean;
    //FProgmanOpen: Boolean;
    FFromService: Boolean;
    NT351: Boolean;
    //
    FFrameProp : TFrameProp;
    //
    procedure UIInitialize(var Message: TMessage); message UI_INITIALIZE;
    //定义系统消息
    procedure SysCommand(var SysMsg: TMessage); message WM_SYSCOMMAND;  //系统消息
    //
    procedure ShowSysMsg(const S : String);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure refreshSetting;
    function readWriteIni(const bWrite: boolean): boolean;
  protected
    procedure popHint(const S: string; const bf: TBalloonFlags=bfInfo; const tmSecs: integer=1000);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(const FromService: Boolean);
    //procedure popHintM(const S: string; const bf: TBalloonFlags=bfInfo; const tmMins: integer=1);
    //procedure errorHint(const S: string; const tmSecs: integer=1000);
    procedure infoHintM(const S: string; const tmMins: integer=1);
    procedure errorHintM(const S: string; const tmMins: integer=1);
  end;

var
  frmMain: TfrmMain;

implementation

uses uFormatMsg, uFrmAboutBox, IniFiles, uTimeUtils;

{$R *.dfm}

procedure TfrmMain.ShowSysMsg(const S : String);
begin
  FFrameProp.ShowSysLog(s);
end;

procedure TfrmMain.SysCommand(var SysMsg: TMessage);
begin
  case SysMsg.WParam of
   SC_MINIMIZE: begin  //如果单击最小化的时候
     //self.TrayIcon1.Visible := true;
     self.Visible := not self.Visible;//互斥，就是你有我没有你没有我就有
     end;
   SC_CLOSE: begin
     //self.TrayIcon1.Visible := true;
     self.Visible := not self.Visible;//互斥，就是你有我没有你没有我就有
   end else begin
     inherited;
   end;
  end;
end;

procedure TfrmMain.TrayIcon1DblClick(Sender: TObject);
begin
  miPropertiesClick(miProperties);
end;

procedure TfrmMain.TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var pt: TPoint;
begin
  if Button = mbRight then begin
    //if not Visible then begin
      //SetForegroundWindow(Handle);
      GetCursorPos(pt);
      PopupMenu.Popup(pt.x, pt.y);
    //end else begin
    //  SetForegroundWindow(Handle);
    //end;
  end;
end;

procedure TfrmMain.Initialize(const FromService: Boolean);
begin
  FFromService := FromService;
  NT351 := (Win32MajorVersion <= 3) and (Win32Platform = VER_PLATFORM_WIN32_NT);
  if NT351 then begin
    if not FromService then begin
      raise Exception.CreateRes(@SServiceOnly);
    end;
    BorderIcons := BorderIcons + [biMinimize];
    BorderStyle := bsSingle;
  end;
  //ReadSettings;
  if FromService then begin
    miClose.Visible := False;
    N1.Visible := False;
  end;
  //TLog4Me.info(BoolToStr(FromService, true));
  //TLog4Me.info('tray: '+BoolToStr(self.TrayIcon1.Visible, true));
  //UpdateStatus;
end;

procedure TfrmMain.UIInitialize(var Message: TMessage);
var b: boolean;
begin
  b := (Message.WParam <> 0);
  //TLog4Me.info('p:' + IntToStr(Message.WParam));
  //TLog4Me.info('b:' + BoolToStr(b, true));
  Initialize(b);
end;

procedure TfrmMain.refreshSetting();
begin
  self.StatusBar1.Panels[0].Text := FFrameProp.getChannelS();
  self.StatusBar1.Panels[1].Text := FFrameProp.getBindStr();
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  Caption := TFrmAboutBox.getAppInfo;
  FFrameProp := TFrameProp.Create(self);
  ShowSysMsg('系统开始启动...');
  FFrameProp.CreateServer(self.Handle);
  FFrameProp.Parent := self;
  FFrameProp.Align := alClient;
  //
  refreshSetting();
  //
  FClosing := False;
  self.TrayIcon1.Icon.Handle := Forms.Application.Icon.Handle;
  //
  ShowSysMsg('系统启动结束.');
end;

destructor TfrmMain.Destroy;
begin
  FFrameProp.Hide;
  FFrameProp.Free;
  inherited;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
//  if FClosing and (not FFromService) then begin
//    FClosing := False;
//    if (Application.MessageBox(PChar(SErrClose), 'Confirm',
//        MB_YESNO + MB_ICONQUESTION) = ID_YES) then begin
//      CanClose := true;
//    end;
//  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  readWriteIni(true);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  readWriteIni(false);
end;

function TfrmMain.readWriteIni(const bWrite: boolean): boolean;
var fileName: string;
  iniFile: TIniFile;
begin
  fileName := ExtractFilePath(ParamStr(0)) + '\' + 'sys.ini';
  iniFile := Tinifile.Create(filename);
  try
    if not bWrite then begin
      top := iniFile.ReadInteger('mainform', 'top', top);
      left := iniFile.ReadInteger('mainform', 'left', left);
      height := iniFile.ReadInteger('mainform', 'height', height);
      width := iniFile.ReadInteger('mainform', 'width', width);
      //
      Result := true;
    end else begin
      // rec param
      iniFile.WriteInteger('mainform', 'top', top);
      iniFile.WriteInteger('mainform', 'left', left);
      iniFile.WriteInteger('mainform', 'height', height);
      iniFile.WriteInteger('mainform', 'width', width);
      Result := true;
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TfrmMain.miCloseClick(Sender: TObject);
begin
  FClosing := True;
  Close;
end;

procedure TfrmMain.miPropertiesClick(Sender: TObject);
begin
  //Show;
  self.Visible := not self.Visible;
  if Visible then begin
    SetForegroundWindow(Handle);
  end;
end;

procedure TfrmMain.MyMsgProc(var Msg: TMessage);
begin
  FFrameProp.MyMsgProc(Msg);
end;

procedure TfrmMain.actnAboutExecute(Sender: TObject);
begin
  TFrmAboutBox.showNewForm(self);
end;

procedure TfrmMain.actnClearExecute(Sender: TObject);
begin
  self.FFrameProp.memoMsg.Clear;
end;

procedure TfrmMain.actnEndExecute(Sender: TObject);
begin
  popHint('服务停止开始...');
  delaySec(1);
  self.FFrameProp.stopServer;
  delaySec(1);
  popHint('服务停止结束.');
end;

procedure TfrmMain.actnEndUpdate(Sender: TObject);
begin
//  if Sender is TAction then begin
//    TAction(Sender).Enabled := FMyHttpServer.IdHttpServer.Active;
//  end;
end;

procedure TfrmMain.actnSettingExecute(Sender: TObject);
begin
  FFrameProp.ShowSetting(self);
  refreshSetting();
end;

procedure TfrmMain.actnStartExecute(Sender: TObject);
begin
  popHint('服务启动开始...');
  delaySec(1);
  self.FFrameProp.restart;
  delaySec(1);
  popHint('服务启动结束.');
end;

procedure TfrmMain.actnStartUpdate(Sender: TObject);
begin
//  if Sender is TAction then begin
//    TAction(Sender).Enabled := not FMyHttpServer.IdHttpServer.Active;
//  end;
end;

procedure TfrmMain.popHint(const S: string; const bf: TBalloonFlags; const tmSecs: integer);
begin
  TrayIcon1.Animate:=true;
  TrayIcon1.BalloonFlags := bf;
  TrayIcon1.Hint := self.Caption;
  TrayIcon1.BalloonTitle := '提示';
  TrayIcon1.BalloonHint := S;
  TrayIcon1.BalloonTimeout := tmSecs;
  TrayIcon1.ShowBalloonHint;
end;

{procedure TfrmMain.popHintM(const S: string; const bf: TBalloonFlags; const tmMins: integer);
begin
  popHint(S, bf, tmMins * 60000);
end;}

procedure TfrmMain.infoHintM(const S: string; const tmMins: integer=1);
begin
  popHint(S, bfInfo, tmMins * 60000);
end;

procedure TfrmMain.errorHintM(const S: string; const tmMins: integer=1);
begin
  popHint(S, bfError, tmMins * 60000);
end;

//function TfrmMain.OnWriteClientData(const text: string): string;
//begin
//  Result := 'echo: ' + Text;
//end;

end.
