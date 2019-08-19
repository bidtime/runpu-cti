unit uFrameProp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, brisdklib, uCallManager,
  uFrmSetting, sgcWebSocket_Classes, uMyHttpServer, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ValEdit, Vcl.ComCtrls, uCmdParser, Vcl.ExtCtrls;

type
   TFuncSendEvent = function(): boolean of object;

  TMyThread = class(TThread)
  protected
    FFuncSendEvent: TFuncSendEvent;
    procedure Execute; override;
    procedure DoMyWorkByWhile;
  public
    constructor Create;
    property FuncSendEvent: TFuncSendEvent read FFuncSendEvent write FFuncSendEvent;
  end;
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
  private
    { Private declarations }
    //FCo: integer;
    FConstMsg: TStrings;
    FMsgStrs: TStrings;
    FCallManager: TCallManager;
    FfrmSetting: TfrmSetting;
    FMyHttpServer: TMyHttpServer;
    FCmdParser: TCmdParser;
    FMyThread: TMyThread;
    //FThreadTimer: TThreadTimer;
    FClosed: boolean;
    function OnWriteClientData(const text: string): string;
    procedure closeDevice;
    procedure broadcast(const S: string);
    procedure OnHttpConnectAfter(Connection: TObject);
    procedure OnShowSysLog(const S: String; const addQueue: boolean;
      const attachLog: boolean);
    //procedure BroadCastTimer(Sender: TThreadTimer);
    function DoSendMsg: boolean;
    procedure insertMemo(const S: String; const addQueue: boolean);
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
  uLogFileU, uHttpUtils;

{$R *.dfm}

procedure TFrameProp.insertMemo(const S : String; const addQueue: boolean);
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
end;

procedure TFrameProp.OnShowSysLog(const S : String; const addQueue: boolean;
  const attachLog: boolean);
//  procedure insertMemo(const S: String);
//  begin
////    TThread.Synchronize(nil,
////      procedure
////      begin
//        if addQueue then begin
//          FMsgStrs.Append(S);
//        end else begin
//          memoMsg.Lines.BeginUpdate;
//          try
//            //self.memoMsg.Lines.Append(TFormatMsg.getMsgSys(S));
//            //self.memoMsg.Lines.Exchange();
//            if memoMsg.Lines.Count >= g_phoneConfig.LogMaxLines then begin
//              self.memoMsg.Lines.Delete(memoMsg.Lines.Count-1);
//            end;
//            self.memoMsg.Lines.insert(0, TFormatMsg.getMsgSys(S));
//          finally
//            memoMsg.Lines.EndUpdate;
//          end;
//        end;
////      end);
//  end;
begin
  if self.FClosed then begin
    exit;
  end;
  log4debug(S);
  if attachLog then begin
    TLogFileU.info(S);
  end;
  TThread.Synchronize(nil,
    procedure
    begin
      insertMemo(S, addQueue);
    end);
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
  FClosed := false;
  FMyThread := TMyThread.create;
  FMyThread.FuncSendEvent := self.DoSendMsg;
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
//  FThreadTimer := TThreadTimer.Create;
//  FThreadTimer.OnThreadTimer := Self.BroadCastTimer; // 给指定 OnThreadTimer 事件
//  FThreadTimer.Interval := 500; // 间隔 0.5 秒
  //Timer1.Enabled := true;
  //DoSendMsg();
  FMyThread.Start;
  ShowSysLog('服务启动结束.');
  //
  FConstMsg.AddStrings(self.memoMsg.Lines);
  //
  g_FileDirProcess.setSubDir(TFileRecUtils.getDirOfRec(TRecInf.CALL));
end;

destructor TFrameProp.Destroy;
begin
  FClosed := true;
  TMyHttpClient.FClosed := true;
  g_FileDirProcess.closed;

  FMyThread.Terminate;
  //Timer1.Enabled := false;
  //FThreadTimer.Free; // 因在父类中已设计好，此处直接 free 即可，像普通类那样对待即可
  FClosed := true;
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

//procedure TFrameProp.BroadCastTimer(Sender: TThreadTimer);

function TFrameProp.DoSendMsg(): boolean;

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

  {procedure dd();
  //var i: integer;
  begin
    inc(FCo);
    //for I := 0 to 100000 do begin
    self.ShowSysLog(IntToStr(FCo) + ' - ' + FormatDateTime('hh:nn:ss zzz', now));
    Application.ProcessMessages;
    //end;
  end;}
var S: string;
begin
  //dd();
  //while popMsg(S) do begin
  //if not TTimer(Sender).Enabled then begin
  if FClosed then begin
    Result := false;
  end else begin
    Result := true;
    popMsg(S);
    if (not s.IsEmpty) then begin
      broadcast(s);
    //end else begin
      // broadcast('broadcast: ' + FormatDateTime('hh:nn:ss zzz', now));
    end;
  end;
  sleep(50);
  Application.ProcessMessages;
  //end;}
end;

procedure TFrameProp.broadcast(const S: string);
//var rep:string;
begin
  if Assigned(FMyHttpServer) then begin
    //rep := TResultDTO<TResultData>.successJson(showState, S);
    TThread.Synchronize(nil,
      procedure
      begin
        FMyHttpServer.broadcast(S);
      end);
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

{ TMyThread }

constructor TMyThread.Create;
begin
  inherited Create(True);
end;

procedure TMyThread.DoMyWorkByWhile;
//var totalCount: Integer;
begin
//  totalCount := 0;
  //上述循环也可以改为
  while (not Terminated) do begin
    //Inc(totalCount);
    //Writeln('第' + IntToStr(totalCount) + '次循环 @' + FormatDateTime('yyyy-MM-dd HH:mm:ss', Now));
    //Sleep(500);
    if not FuncSendEvent() then begin
      break;
    end;
  end;
end;

procedure TMyThread.Execute;
begin
  FreeOnTerminate := True;
  DoMyWorkByWhile;
end;

end.
