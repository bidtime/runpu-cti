unit uHttpServerBase;

interface

uses
  Classes, sgcWebSocket_Classes, sgcWebSocket_Server, sgcWebSocket, sgcWebSocket_Const,
  IdContext, IdCustomHTTPServer, HTTPApp, HTTPProd, sgcWebSocket_Classes_Indy;

type
  //TGetStrProc2 = procedure(const S1, S2: string) of object;
  TGetStrFunc = function(const S: string): string of object;
  THttpServerBase = class(TObject)
  protected
    { Private declarations }
    FHost: string;
    FPort: Integer;
    //
    FURL: string;
    FRootDir:string;
    //
    FCreated: boolean;
    FIdHttpServer: TsgcWebSocketHTTPServer;
    //
    FOnShowLogs: TGetStrProc;
    FOnWriteClientData: TGetStrFunc;
    FOnConnectAfter: TNotifyEvent;
    FOnMessageEvent: TsgcWSMessageEvent;
    //
    function start_raw(const host: string; const port: integer; const root: string): boolean; overload;
    function getPortS(): string;
    procedure setPortS(const port: string);
  private
  protected
    function restart(): boolean; overload;
    //
    procedure DoOnShowLogs(const S: string); overload;
    procedure DoOnShowLogs(const S1, S2: string); overload;
    procedure DoOnShowLogs(const S1: string; const I:Integer); overload;
    //
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo:
      TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo); virtual; abstract;
    procedure WSServerConnect(Connection: TsgcWSConnection);
    procedure WSServerDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure WSServerError(Connection: TsgcWSConnection; const Error: string);
    procedure WSServerMessage(Connection: TsgcWSConnection; const Text: string);
  public
    { Public declarations }
    constructor Create(); overload;
    //constructor Create(idSrv: TIdHTTPServer); overload;
    destructor Destroy; override;
    function start(const host: string; const port: integer; const root: string): boolean; overload;
    function start(const host: string; const port: string; const root: string): boolean; overload;
    function start(): boolean; overload;
    function restart(const host: string; const port: integer): boolean; overload;
    function stopIt(): boolean;
    //
    procedure WriteData(client: TObject; const text: String); overload;
    procedure WriteData(Connection: TsgcWSConnection; const text: String); overload;
    procedure broadcast(const aMessage: string;
      const aChannel: string = ''; const aProtocol: string = '';
      const Exclude: String = ''; const Include: String = '');
    //
    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property PortS: String read GetPortS write SetPortS;
    //
    property RootDir: string read FRootDir write FRootDir;
    property URL: string read FURL write FURL;
    //
    property IdHttpServer: TsgcWebSocketHTTPServer read FIdHttpServer write FIdHttpServer;
    property OnShowLogs: TGetStrProc read FOnShowLogs write FOnShowLogs;
    property OnMessageEvent: TsgcWSMessageEvent read FOnMessageEvent write FOnMessageEvent;
    property OnWriteClientData: TGetStrFunc read FOnWriteClientData write FOnWriteClientData;
    property OnConnectAfter: TNotifyEvent read FOnConnectAfter write FOnConnectAfter;
  end;

implementation

uses Dialogs, SysUtils, uResultDTO, uCmdType, uCmdException, uCmdResponse, uTimeUtils;

{ THttpServerBase }

constructor THttpServerBase.Create;
begin
  inherited;
  FCreated := true;
  FIdHttpServer := TsgcWebSocketHTTPServer.create(nil);
  FIdHttpServer.OnCommandGet := IdHTTPServer1CommandGet;
  FIdHttpServer.OnConnect := WSServerConnect;
  FIdHttpServer.OnError := WSServerError;
  FIdHttpServer.OnMessage := WSServerMessage;
  FIdHttpServer.OnDisconnect := WSServerDisconnect;
  //
end;

{constructor THttpServerBase.Create(idSrv: TIdHTTPServer);
begin
  inherited create;
  FCreated := false;
  FIdHttpServer := idSrv;
  FIdHttpServer.OnCommandGet := IdHTTPServer1CommandGet;
end;}

procedure THttpServerBase.WriteData(client: TObject; const text: String);
begin
  WriteData(TsgcWSConnection(client), text);
end;

procedure THttpServerBase.WriteData(Connection: TsgcWSConnection; const text: String);
begin
  if Assigned(Connection) and (Connection.Active) then begin
    //DoOnShowLogs('send: IP->', Connection.IP + ' - ' + text);
    Connection.WriteData(text);
  end else begin
    //DoOnShowLogs('send: ', 'error, because of client is closed.');
  end;
end;

function THttpServerBase.start(const host: string; const port: string; const root: string): boolean;
begin
  Result := self.start(host, strtoint(trim(port)), root);
end;

function THttpServerBase.start(const host: string; const port: integer; const root: string): boolean;
begin
  Result := self.start_raw(trim(host), port, trim(root));
end;

function THttpServerBase.start_raw(const host: string; const port: integer; const root: string): boolean;
begin
  if FIdHttpServer.Active then begin
    stopIt();
  end;
  DoOnShowLogs('start: ', 'http server begin...');
  DoOnShowLogs('bind: ', host + '/' + IntToStr(port));
  //
  try
    {FIdHttpServer.Bindings.Clear;  // 以下执行顺序，不要错，否则服务不可用
    // 1. 先要绑定的端口，一定设置此项，这是真正要绑定的端口;
    FIdHttpServer.DefaultPort := port;
    // 2. 再绑主机IP
    FIdHttpServer.Bindings.Add.IP := host;
    // 3. 启动服务器
    FIdHttpServer.Active := True;}

    //if chkSSL.Checked then
    //  WSServer.Port := StrToInt(txtSSLPort.Text)
    //else
      FIdHttpServer.Port := port;

    // ... bindings
    FIdHttpServer.Bindings.Clear;
    With FIdHttpServer.Bindings.Add do
    begin
      Port := port;
      IP := host;
    end;
    {if chkSSL.Checked then
    begin
      With WSServer.Bindings.Add do
      begin
        Port := StrToInt(txtSSLPort.Text);
        IP := txtHost.Text;
      end;
      WSServer.SSLOptions.Port := StrToInt(txtSSLPort.Text);
    end;
    if chkFlash.Checked then
    begin
      With WSServer.Bindings.Add do
      begin
        Port := 843;
        IP := txtHost.Text;
      end;
    end;}

    // ... active
    FIdHttpServer.Active := True;
    //DoOnShowLogs('start: ', 'success.');
  except On e: Exception do begin
      DoOnShowLogs('start: ' + 'error->' + e.Message);
    end;
  end;
  //
  FURL := 'http://' + host + ':' + IntToStr(port) +'/';
  DoOnShowLogs('url: ' + FURL);
  //
  FRootDir := root;
  DoOnShowLogs('root: ' + FRootDir);
  //
  Result := FIdHttpServer.Active;
  //
  DoOnShowLogs('start: ', 'http server end, '
    + BoolToStr(FIdHttpServer.Active, true) + '.');
end;

procedure THttpServerBase.setPortS(const port: string);
begin
  FPort := StrToInt(port);
end;

function THttpServerBase.start: boolean;
begin
  Result := start(FHost, FPort, FRootDir);
end;

function THttpServerBase.stopIt: boolean;
begin
  DoOnShowLogs('stop: ', 'http server stop begin...');
  if FIdHttpServer.Active then begin
    DoOnShowLogs('stop: ', host + '/' + IntToStr(port));
    FIdHttpServer.Active := false;
  end else begin
    DoOnShowLogs('stop: ', host + '/' + IntToStr(port));
  end;
  delaySec(1);
  Result := not FIdHttpServer.Active;
  DoOnShowLogs('stop: ', 'http server stop end, '
    + BoolToStr(FIdHttpServer.Active, true) + '.');
end;

destructor THttpServerBase.Destroy;
begin
  if FIdHttpServer.Active then begin
    FIdHttpServer.Active := false;
  end;
  if FCreated then begin
    FIdHttpServer.Free;
  end;
  inherited;
end;

procedure THttpServerBase.DoOnShowLogs(const S1: string; const I: Integer);
begin
  DoOnShowLogs(S1 + IntToStr(I));
end;

function THttpServerBase.getPortS: string;
begin
  Result := IntToStr(FPort);
end;

function THttpServerBase.restart(const host: string; const port: integer): boolean;

  function needStart(): boolean;
  begin
    Result := false;
    if FIdHttpServer.Active then begin
      if not SameText(FHost, host) then begin
        if (FPort<>port) then begin
          self.Host := host;
          self.Port := port;
          //
          Result := true;
        end;
      end;
    end else begin
      Result := true;
    end;
  end;

begin
  if needStart() then begin
    Result := restart;
  end else begin
    Result := true;
  end;
end;

function THttpServerBase.restart: boolean;
var b: boolean;
begin
  DoOnShowLogs('restart: ', 'http server start...');
  b := false;
  if stopIt then begin
    b := start;
  end;
  DoOnShowLogs('restart: ', 'http server end.');
  Result := b;
end;

procedure THttpServerBase.DoOnShowLogs(const S1, S2: string);
begin
  DoOnShowLogs(S1 + S2);
end;

procedure THttpServerBase.DoOnShowLogs(const S: string);
begin
  if Assigned(FOnShowLogs) then begin
    FOnShowLogs(S);
  end;
end;

procedure THttpServerBase.WSServerConnect(Connection: TsgcWSConnection);
begin
  DoOnShowLogs('client connected: IP->', Connection.IP + '/' + IntToStr(Connection.Port));
  if Assigned(FOnConnectAfter) then begin
    FOnConnectAfter(Connection);
  end;
end;

procedure THttpServerBase.WSServerDisconnect(Connection: TsgcWSConnection;
  Code: Integer);
begin
  DoOnShowLogs('client disconnected: IP->', Connection.IP + '/' + IntToStr(Connection.Port) + ', code('
    + IntToStr(Code) + ')');
end;

procedure THttpServerBase.WSServerError(Connection: TsgcWSConnection; const
    Error: string);
begin
  DoOnShowLogs('client error: IP->', Connection.IP + '/' + IntToStr(Connection.Port) + ', Error(' + Error + ')');
end;

procedure THttpServerBase.WSServerMessage(Connection: TsgcWSConnection; const
    Text: string);

  function error(const e: Exception): string;
  begin
    Result := TCmdResponse.errorJson(EV_SHOW_LOG, nil, e.Message);
  end;

begin
  DoOnShowLogs('');
  DoOnShowLogs('recv: IP->', Connection.IP + '/' + IntToStr(Connection.Port) + ' - ' + Text);
  try
    if Assigned(FOnWriteClientData) then begin
      WriteData(Connection, FOnWriteClientData(Text));
    end;
    //
    if Assigned(FOnMessageEvent) then begin
      FOnMessageEvent(Connection, Text);
    end;
  except
    on e: TCmdException do begin
      DoOnShowLogs('error: ', '(' + e.ClassName + '), ' + e.Message);
      WriteData(Connection, e.Message);
    end;
    on e: Exception do begin
      DoOnShowLogs('error: ', '(' + e.ClassName + '), ' + e.Message);
      WriteData(Connection, error(e));
    end;
  end;
end;

procedure THttpServerBase.broadcast(const aMessage, aChannel, aProtocol,
  Exclude, Include: String);
begin
  //DoOnShowLogs('broadcast: ', aMessage);
  FIdHttpServer.Broadcast(aMessage, aChannel, aProtocol, Exclude, Include);
end;

//procedure TForm1.IdHTTPServer1CommandGet(AThread: TIdPeerThread;
//  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
//begin
//浏览器请求http://127.0.0.1:8008/index.html?a=1&b=2
  //ARequestInfo.Document  返回    /index.html
  //ARequestInfo.QueryParams 返回  a=1b=2
  //ARequestInfo.Params.Values['name']   接收get,post过来的数据
  ////webserver发文件
  {LFilename := ARequestInfo.Document;
  if LFilename = '/' then
  begin
    LFilename := '/'+trim(edit_index.Text);
  end;
  LPathname := RootDir + LFilename;
  if FileExists(LPathname) then begin
      AResponseInfo.ContentStream := TFileStream.Create(LPathname, fmOpenRead + fmShareDenyWrite);//发文件

  end
  else
  begin
      AResponseInfo.ResponseNo := 404;
      AResponseInfo.ContentText := '找不到' + ARequestInfo.Document;
  end; }

   //发html文件
   //AResponseInfo.ContentEncoding:='utf-8';
   //AResponseInfo.ContentType :='text/html';
   //AResponseInfo.ContentText:='<html><body>好</body></html>';

   //发xml文件
   {AResponseInfo.ContentType :='text/xml';
   AResponseInfo.ContentText:='<?xml version="1.0" encoding="utf-8"?>'
   +'<students>'
   +'<student sex = "male"><name>'+AnsiToUtf8('陈')+'</name><age>14</age></student>'
   +'<student sex = "female"><name>bb</name><age>16</age></student>'
   +'</students>';}

   //下载文件时，直接从网页打开而没有弹出保存对话框的问题解决
//AResponseInfo.CustomHeaders.Values['Content-Disposition'] :='attachment; filename="'+文件名+'"';
//替换 IIS
  {AResponseInfo.Server:='IIS/6.0';
  AResponseInfo.CacheControl:='no-cache';
  AResponseInfo.Pragma:='no-cache';
  AResponseInfo.Date:=Now;}
//end;

end.
