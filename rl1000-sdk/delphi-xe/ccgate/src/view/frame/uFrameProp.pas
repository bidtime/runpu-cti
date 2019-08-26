unit uFrameProp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, brisdklib, uCallManager,
  uFrmSetting, sgcWebSocket_Classes, uMyHttpServer, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ValEdit, Vcl.ComCtrls, uCmdParser, Vcl.ExtCtrls, uFrameMemo;

type
  TFrameProp = class(TFrame)
    Pages: TPageControl;
    PropPage: TTabSheet;
    StatPage: TTabSheet;
    frameMemoQueue: TframeMemo;
    frameMemoLog: TframeMemo;
    TabSheet1: TTabSheet;
    frameMemoLogD: TframeMemo;
  private
    { Private declarations }
    //FCo: integer;
    FCallManager: TCallManager;
    FfrmSetting: TfrmSetting;
    FMyHttpServer: TMyHttpServer;
    FCmdParser: TCmdParser;
    //FMyThread: TMyThread;
    //FThreadTimer: TMyThread;
    function OnWriteClientData(const text: string): string;
    procedure closeDevice;
    procedure broadcast(const S: string);
    procedure OnHttpConnectAfter(Connection: TObject);
    procedure OnShowSysLog(const S: String; const addQueue: boolean;
      const logD: boolean);
    //procedure BroadCastTimer(Sender: TObject);
    procedure DoSendQueue(const S: string);
    //function DoSendMsg(const bTerminated: boolean): boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure createServer(const lFrmHandle: longint);
    procedure stopServer();
    procedure MyMsgProc(var Msg: TMessage); message BRI_EVENT_MESSAGE;
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
  uPhoneConfig, uShowMsgBase, uFileDataPost, uFileRecUtils, uRecInf, uHttpException;

{$R *.dfm}

procedure TFrameProp.OnShowSysLog(const S: String; const addQueue: boolean;
  const logD: boolean);
begin
  if (addQueue) then begin
    self.frameMemoQueue.add(S);
  end else if logD then begin
    self.frameMemoLogD.add(S);
  end else begin
    self.frameMemoLog.add(S);
  end;
  Application.ProcessMessages;
  Sleep(0);
end;

procedure TFrameProp.ShowSysLog(const S: String);
begin
  OnShowSysLog(S, false, false);
end;

procedure TFrameProp.stopServer;
begin
  ShowSysLog('����رտ�ʼ...');
  FMyHttpServer.stopIt;
  closeDevice();
  ShowSysLog('����رս���.');
end;

constructor TFrameProp.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
//  FMyThread := TMyThread.create(50);
//  FMyThread.FuncSendEvent := self.DoSendMsg;
  self.frameMemoQueue.OnGetQueue := DoSendQueue;
  self.frameMemoQueue.Timer1.Interval := 200;
  //self.frameMemoQueue.Logd := false;
  //self.frameMemoLog.Logd := false;
  self.frameMemoLogD.Logd := true;
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
      ShowSysLog('cfg: ��������Ϊ�գ�������');
    end else begin
      ShowSysLog('cfg: ��������Ϊ ' + g_PhoneConfig.CallingNo);
    end;
    self.FCallManager.OpenDevice(g_PhoneConfig);
  end;

begin
  ShowSysLog('����ʼ����...');
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
  //FMyThread.Start;
  ShowSysLog('������������.');
  //
  g_FileDirProcess.setSubDir(TFileRecUtils.getDirOfRec(TRecInf.CALL));
end;

destructor TFrameProp.Destroy;
begin
//  FMyThread.Terminate;
//  FMyThread.WaitFor;
//  FMyThread.Free;
  //FThreadTimer.Free; // ���ڸ���������ƺã��˴�ֱ�� free ���ɣ�����ͨ�������Դ�����
  FMyHttpServer.free;
  //
  CloseDevice();
  FCallManager.Free;
  FfrmSetting.Free;
  FCmdParser.Free;
  inherited;
end;

procedure TFrameProp.DoSendQueue(const S: string);
begin
  if (not S.IsEmpty) then begin
    broadcast(S);
  end;
//  TThread.Synchronize(nil,
//    procedure
//    begin
//    end);
  Application.ProcessMessages;
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

{function TFrameProp.DoSendMsg(const bTerminated: boolean): boolean;

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

var S: string;
begin
  if bTerminated then begin
    Result := false;
  end else begin
    Result := true;
    popMsg(S);
    if (not s.IsEmpty) then begin
      broadcast(s);
    end;
  end;
end;}

procedure TFrameProp.broadcast(const S: string);
//var rep:string;
begin
  if Assigned(FMyHttpServer) then begin
    FMyHttpServer.broadcast(S);
    //rep := TResultDTO<TResultData>.successJson(showState, S);
    //TThread.Synchronize(nil,
    //  procedure
    //  begin
    //    FMyHttpServer.broadcast(S);
    //  end);
  end;
end;

procedure TFrameProp.restart;
begin
  ShowSysLog('����������ʼ...');
  self.FCallManager.restartDevice(g_PhoneConfig);
  FMyHttpServer.restart(g_PhoneConfig.Host, g_PhoneConfig.Port);
  ShowSysLog('������������.');
end;

procedure TFrameProp.clearMsg;
begin
  self.frameMemoQueue.Clear;
  self.frameMemoLog.Clear;
  self.frameMemoLogD.Clear;
end;

procedure TFrameProp.closed;
begin
  g_closed := true;
end;

procedure TFrameProp.closeDevice();
begin
  self.FCallManager.CloseDevice;
end;

procedure TFrameProp.OnHttpConnectAfter(Connection: TObject);
var
  S, res: string;
  //I: integer;
begin
  {for I := 0 to self.FConstMsg.Count - 1 do begin
    S := self.FConstMsg[I];
    if not s.IsEmpty then begin
      res := TCmdResponse.successJson(EV_SHOW_LOG, S);
      self.FMyHttpServer.writeData(Connection, res);
    end;
    if i>=5 then begin
      break;
    end;
  end;}
  S := 'server is started...';
  res := TCmdResponse.successJson(EV_SHOW_LOG, S);
  self.FMyHttpServer.writeData(Connection, res);
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
