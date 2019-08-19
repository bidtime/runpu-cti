unit uFrameProp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, brisdklib, uCallManager,
  uFrmSetting, sgcWebSocket_Classes, uMyHttpServer, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ValEdit, Vcl.ComCtrls, uCmdParser, Vcl.ExtCtrls;

type
  TFrameProp = class(TFrame)
    Pages: TPageControl;
    PropPage: TTabSheet;
    PortGroup: TGroupBox;
    memoMsg: TMemo;
    StatPage: TTabSheet;
    GroupBox1: TGroupBox;
    ValueListEditor1: TValueListEditor;
    btnApply: TButton;
    btnTest: TButton;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FCo: integer;
    FConstMsg: TStrings;
    FMsgStrs: TStrings;
    FCallManager: TCallManager;
    FfrmSetting: TfrmSetting;
    FMyHttpServer: TMyHttpServer;
    FCmdParser: TCmdParser;
    function OnWriteClientData(const text: string): string;
    procedure closeDevice;
    procedure broadcast(const S: string);
    procedure OnHttpConnectAfter(Connection: TObject);
    procedure OnShowSysLog(const S: String; const addQueue: boolean;
      const attachLog: boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure createServer(const lFrmHandle: longint);
    procedure stopServer();
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure ShowSysLog(const S: String);
    procedure restart;
    //
    function showSetting(AOwner: TComponent): boolean;
    procedure clearMsg();
    function getBindStr: string;
    function getChannelS: string;
    procedure closed();
  end;

implementation

uses uFormatMsg, uFrmAboutBox, StrUtils, uResultDTO, uCmdType, uCmdResponse,
  uPhoneConfig, uShowMsgBase, uFileDataPost, uFileRecUtils, uRecInf, uLog4me,
  uLogFileU;

{$R *.dfm}

procedure TFrameProp.OnShowSysLog(const S : String; const addQueue: boolean;
  const attachLog: boolean);
  procedure insertMemo(const S: String);
  begin
    TThread.Synchronize(nil,
      procedure
      begin
        if addQueue then begin
          FMsgStrs.Append(S);
        end else begin
          memoMsg.Lines.BeginUpdate;
          try
            //self.memoMsg.Lines.Append(TFormatMsg.getMsgSys(S));
            //self.memoMsg.Lines.Exchange();
            if memoMsg.Lines.Count >= g_phoneConfig.LogMaxLines then begin
              self.memoMsg.Lines.Delete(memoMsg.Lines.Count-1);
            end;
            self.memoMsg.Lines.insert(0, TFormatMsg.getMsgSys(S));
          finally
            memoMsg.Lines.EndUpdate;
          end;
        end;
      end);
  end;
begin
  log4debug(S);
  if attachLog then begin
    TLogFileU.info(S);
  end;
  insertMemo(S);
  Application.ProcessMessages;
  Sleep(0);
end;

procedure TFrameProp.ShowSysLog(const S: String);
begin
  OnShowSysLog(S, false, false);
end;

procedure TFrameProp.stopServer;
begin
  ShowSysLog('服务关闭开始...');
  FMyHttpServer.stopIt;
  closeDevice();
  ShowSysLog('服务关闭结束.');
end;

constructor TFrameProp.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  memoMsg.Clear;
  FConstMsg := TStringList.Create;
  FMsgStrs := TStringList.Create;
end;

procedure TFrameProp.CreateServer(const lFrmHandle: longint);

  procedure createHttpSrv();
    procedure startHttpSrv();
    begin
      FMyHttpServer.Host := g_PhoneConfig.Host;
      FMyHttpServer.Port := g_PhoneConfig.Port;
      //FMyHttpServer.RootDir := edtRoot.Text;
      // start
      FMyHttpServer.start();
    end;
  begin
    FMyHttpServer := TMyHttpServer.create();
    FMyHttpServer.OnShowLogs := ShowSysLog;
    FMyHttpServer.OnWriteClientData := OnWriteClientData;
    FMyHttpServer.OnConnectAfter := OnHttpConnectAfter;
    //
    startHttpSrv();
  end;

  procedure createDevice();
  begin
    if g_PhoneConfig.CallingNo.IsEmpty then begin
      ShowSysLog('cfg: 本机号码为空，请设置');
    end else begin
      ShowSysLog('cfg: 本机号码为 ' + g_PhoneConfig.CallingNo);
    end;
    self.FCallManager.OpenDevice(g_PhoneConfig);
  end;

begin
  ShowSysLog('服务开始启动...');
  //
  g_ShowMsgBase.OnShowLogs := OnShowSysLog;
  //
  FfrmSetting := TfrmSetting.Create(self);
  FCallManager := TCallManager.Create(lFrmHandle);
  FCallManager.OnShowLogs := OnShowSysLog;
  //
  FCmdParser := TCmdParser.Create();
  FCmdParser.OnShowLogs := OnShowSysLog;
  //
  createDevice();
  //
  createHttpSrv();
  //
  Timer1.Enabled := true;
  ShowSysLog('服务启动结束.');
  //
  FConstMsg.AddStrings(self.memoMsg.Lines);
  //
  g_FileDirProcess.setSubDir(TFileRecUtils.getDirOfRec(TRecInf.CALL));
end;

destructor TFrameProp.Destroy;
begin
  Timer1.Enabled := false;
  FMyHttpServer.free;
  //
  CloseDevice();
  FCallManager.Free;
  FfrmSetting.Free;
  FCmdParser.Free;
  FMsgStrs.Free;
  FConstMsg.Free;
  inherited;
end;

function TFrameProp.ShowSetting(AOwner: TComponent): boolean;
begin
  Result := false;
  if (FfrmSetting.ShowModal = mrOK) then begin
    if (FfrmSetting.outPrefixChg()) then begin
      FCallManager.reloadCfg();
    end;
    if (FMyHttpServer.restart(g_PhoneConfig.Host, g_PhoneConfig.Port)) then begin
      Result := true;
    end;
  end;
end;

procedure TFrameProp.MyMsgProc(var Msg: TMessage);
begin
  FCallManager.MyMsgProc(Msg);
end;

procedure TFrameProp.Timer1Timer(Sender: TObject);

  function popMsg(var S: string): boolean;
  begin
    if self.FMsgStrs.Count > 0 then begin
      Result := true;
      S := self.FMsgStrs[0];
      self.FMsgStrs.Delete(0);
    end else begin
      Result := false;
    end;
  end;

  procedure dd();
  //var i: integer;
  begin
    inc(FCo);
    //for I := 0 to 100000 do begin
    self.ShowSysLog(IntToStr(FCo) + ' - ' + FormatDateTime('hh:nn:ss zzz', now));
    Application.ProcessMessages;
    //end;
  end;

var
  S: string;
begin
  //dd();
  while popMsg(S) do begin
    if not TTimer(Sender).Enabled then begin
      break;
    end;
    if (not s.IsEmpty) then begin
      broadcast(s);
    //end else begin
      // broadcast('broadcast: ' + FormatDateTime('hh:nn:ss zzz', now));
    end;
    sleep(0);
  end;
end;

procedure TFrameProp.broadcast(const S: string);
//var rep:string;
begin
  if Assigned(FMyHttpServer) then begin
    //rep := TResultDTO<TResultData>.successJson(showState, S);
    FMyHttpServer.broadcast(S);
  end;
end;

procedure TFrameProp.restart;
begin
  ShowSysLog('服务重启开始...');
  self.FCallManager.restartDevice(g_PhoneConfig);
  FMyHttpServer.restart(g_PhoneConfig.Host, g_PhoneConfig.Port);
  ShowSysLog('服务重启结束.');
end;

procedure TFrameProp.clearMsg;
begin
  memoMsg.Clear;
end;

procedure TFrameProp.closed;
begin
  g_FileDirProcess.closed;
end;

procedure TFrameProp.closeDevice();
begin
  self.FCallManager.CloseDevice;
end;

procedure TFrameProp.OnHttpConnectAfter(Connection: TObject);
var
  S, res: string;
  I: integer;
begin
  for I := 0 to self.FConstMsg.Count - 1 do begin
    S := self.FConstMsg[I];
    if not s.IsEmpty then begin
      res := TCmdResponse.successJson(EV_SHOW_LOG, S);
      self.FMyHttpServer.writeData(Connection, res);
    end;
    if i>=5 then begin
      break;
    end;
  end;
end;

function TFrameProp.OnWriteClientData(const text: string): string;
begin
  Result := FCmdParser.parser(text, FCallManager);
end;

function TFrameProp.getChannelS(): string;
begin
  Result := FCallManager.getChannelS();
end;

function TFrameProp.getBindStr(): string;
begin
  Result := g_PhoneConfig.httpInfo;
end;

end.
