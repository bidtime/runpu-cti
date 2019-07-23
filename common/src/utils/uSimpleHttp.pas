unit uSimpleHttp;

interface

uses
  Classes, System.Net.HttpClient, System.Net.HttpClientComponent;

type

  TSimpleHttp = class(TNetHTTPClient)
  private
    FReceiveDataEvent: TReceiveDataEvent;
    procedure OnReceiveData(const Sender: TObject; AContentLength: Int64;
      AReadCount: Int64; var Abort: Boolean);
   // procedure download(const url: string; const sub: string);
   // function dolw(const url: string): string;
  public
    { Public declarations }
    //constructor Create();
    function get(const url: string; const tmConn, tmResp: integer): string;
    function save(const url: string; const dst: string; const tmConn, tmResp: integer): boolean;
    //
    property ReceiveDataEvent: TReceiveDataEvent read FReceiveDataEvent write FReceiveDataEvent;
  end;

  THttpHelper = class(TNetHTTPClient)
  public
    { Public declarations }
    class function get(const url: string; const tmConn, tmResp: integer;
      const ev: TReceiveDataEvent=nil): string;
    class function save(const url: string; const dst: string; const tmConn, tmResp: integer;
      const ev: TReceiveDataEvent=nil): boolean;
  end;

implementation

uses System.Net.URLClient, Windows, Forms, SysUtils;

{ THttpHelper }

class function THttpHelper.get(const url: string; const tmConn, tmResp: integer;
  const ev: TReceiveDataEvent): string;
var
  http: TSimpleHttp;
begin
  http := TSimpleHttp.Create(nil);
  try
    http.ReceiveDataEvent := ev;
    Result := http.get(url, tmConn, tmResp);
  finally
   http.Free;
  end;
end;

class function THttpHelper.save(const url: string; const dst: string;
  const tmConn, tmResp: integer; const ev: TReceiveDataEvent): boolean;
var
  http: TSimpleHttp;
begin
  http := TSimpleHttp.Create(nil);
  try
    http.ReceiveDataEvent := ev;
    Result := http.save(url, dst, tmConn, tmResp);
  finally
   http.Free;
  end;
end;

function TSimpleHttp.get(const url: string; const tmConn, tmResp: integer): string;
  function dl(httpClient: THTTPClient): string;
  var
    lResponse: IHTTPResponse;
    ss: TStringStream;
  begin
    ss := TStringStream.Create;
    try
      lResponse := httpClient.Get(url, ss);
      if (lResponse.StatusCode = 200) then begin
        Result := ss.DataString;
      end else begin
        raise Exception.Create('Error: http code=' + IntToStr(lResponse.StatusCode));
      end;
    finally
      ss.Free;
    end;
  end;
var
  httpClient: THTTPClient;
begin
  httpClient := THTTPClient.Create;
  try
    httpClient.ConnectionTimeout := tmConn;
    httpClient.ResponseTimeout := tmResp;
    Result := dl(httpClient);
  finally
    httpClient.Free;
  end;
end;

function TSimpleHttp.save(const url: string; const dst: string; const tmConn, tmResp: integer): boolean;

  procedure save2file(ms: TMemoryStream);
  var f: string;
    u: TURI;
  begin
    u := TURI.Create(url);
    //f := sub + u.Path;
    //f := f.Replace('/', '\');
    f := dst + '.dl';
    DeleteFile(PChar(f));
    ForceDirectories(ExtractFilePath(f));
    ms.SaveToFile(f);
    RenameFile(f, dst);
    Application.ProcessMessages;
    Sleep(100);
  end;

  function download(httpClient: THTTPClient): boolean;
  var
    MyHTTPResponse: IHTTPResponse;
    ms: TMemoryStream;
  begin
    Result := false;
    ms := TMemoryStream.Create;
    try
      //开始下载,保存到本地
      MyHTTPResponse := httpClient.Get(url, ms);
      if (MyHTTPResponse.StatusCode = 200) then begin
        save2file(ms);
        Result := true;
      end;
    finally
      ms.Free;
    end;
  end;

var
  httpClient: THTTPClient;
begin
  httpClient := THTTPClient.Create;
  try
    httpClient.ConnectionTimeout := tmConn;
    httpClient.ResponseTimeout := tmResp;
    httpClient.OnReceiveData := OnReceiveData;
    Result := download(httpClient);
  finally
    httpClient.Free;
  end;
end;

//procedure TSimpleHttp.btnStart(const url: string);
//begin
//  download(url, ExtractFilePath(ParamStr(0)));
//end;

procedure TSimpleHttp.OnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var Abort: Boolean);
begin
  //加上这句界面不卡死.
  Application.ProcessMessages;
  if Assigned(FReceiveDataEvent) then begin
    FReceiveDataEvent(Sender, AContentLength, AReadCount, Abort);
  end;
  //ProgressBar1.Position := AReadCount;
  //lblState.Caption := '下载中...';
end;

end.
