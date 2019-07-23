unit uHttpAsUtils;

interface

uses
  Classes, System.Net.HttpClient, System.Net.HttpClientComponent, System.Net.mime, SysUtils;

type
  TMyHttpClient = class(TNetHTTPClient)
  private
    ssRst: TStringStream;
    FGetData: TGetStrProc;
    procedure DoOnRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    function postGet(const url, method: string; const ob: TObject;
      const tmConn, tmRes: integer; const encode: TEncoding): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    //
    property OnGetData: TGetStrProc read FGetData write FGetData;
  end;

  THttpAsUtils = class(TMyHttpClient)
  private
    { Private declarations }
    class var fCookie: string;
  public
    { Public declarations }
     function postJson(const url, S: string; const tmConn,
      tmRes: integer): boolean; static;
     function post(const url: string;
      const ob: TObject; const tmConn, tmRes: integer): boolean; overload;
    function post(const url: string; const ob: TObject;
      const tmConn, tmRes: integer; const encode: TEncoding): boolean; overload;
    function upload(const url, fileName: String; const tmConn: integer;
      const tmRes: integer): string;
    function post(const url, S: string; const tmConn, tmRes: integer):
      boolean; overload; static;
    function get(const url: string; const S: string; const tmConn, tmRes:
      integer): boolean; overload;
    function get(const url: string; const ob: TObject; const tmConn,
      tmRes: integer; const encode: TEncoding): boolean; overload; static;
    procedure addCookie(const cookie: string);
  end;

implementation

uses System.NetConsts, System.Net.URLClient, uShowMsgBase, Forms;

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

procedure THttpAsUtils.addCookie(const cookie: string);
begin
  THttpAsUtils.fCookie := cookie;
end;

function THttpAsUtils.upload(Const url, fileName: String;
  const tmConn: integer; const tmRes: integer): boolean;
var
  multFormData: TMultipartFormData;
begin
  multFormData := TMultipartFormData.Create;
  try
    multFormData.AddFile('file', FileName);
    Result := post(url, multFormData, tmConn, tmRes);
  finally
    multFormData.Free;
  end;
end;

function THttpAsUtils.post(const url: string;
  const ob: TObject; const tmConn, tmRes: integer): boolean;
begin
  Result := post(url, ob, tmConn, tmRes, TEncoding.UTF8);
end;

function THttpAsUtils.post(const url: string; const S: string;
  const tmConn, tmRes: integer): boolean;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Text := S;
    Result := THttpAsUtils.post(url, strs, tmConn, tmRes);
  finally
    strs.Free;
  end;
end;

function THttpAsUtils.get(const url: string; const S: string;
  const tmConn, tmRes: integer): boolean;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Text := S;
    Result := THttpAsUtils.get(url, strs, tmConn, tmRes, TEncoding.UTF8);
  finally
    strs.Free;
  end;
end;

function THttpAsUtils.postJson(const url: string; const S: string;
  const tmConn, tmRes: integer): boolean;
var ss: TStringStream;
begin
  ss := TStringStream.Create(S);
  try
    ss.WriteString(S);
    Result := THttpAsUtils.post(url, ss, tmConn, tmRes);
  finally
    ss.Free;
  end;
end;

function THttpAsUtils.post(const url: string; const ob: TObject;
  const tmConn, tmRes: integer; const encode: TEncoding): boolean;
begin
  Result := THttpAsUtils.postGet(url, sHTTPMethodPost, ob, tmConn, tmRes, encode);
end;

function THttpAsUtils.get(const url: string; const ob: TObject;
  const tmConn, tmRes: integer; const encode: TEncoding): boolean;
begin
  Result := THttpAsUtils.postGet(url, sHTTPMethodGet, ob, tmConn, tmRes, encode);
end;

{ TMyHttpClient }

constructor TMyHttpClient.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  ssRst := TStringStream.create;
  self.AllowCookies := true;
  self.Asynchronous := true;
  //
  //self.ConnectionTimeout := tmConn; // 10秒
  //self.ResponseTimeout := tmRes;
  self.AcceptCharSet := 'utf-8';
  self.AcceptEncoding := 'utf-8';
  self.AcceptLanguage := 'zh-CN';
  self.Accept := 'application/json';
  //self.ContentType := 'application/json';
  //self.ContentType := 'multipart/form-data';
  self.UserAgent := DefaultUserAgent;//'Embarcadero URI Client/1.0';
  //
  self.OnRequestCompleted := DoOnRequestCompleted;
end;

destructor TMyHttpClient.Destroy;
begin
  ssRst.Free;
  inherited Destroy;
end;

procedure TMyHttpClient.DoOnRequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin
  if Assigned(FGetData) then begin
    if AResponse.statusCode=200 then begin
      FGetData(ssRst.DataString)
    end else begin
      FGetData('');
    end;
  end;
end;

function TMyHttpClient.postGet(const url, method: string; const ob: TObject;
  const tmConn, tmRes: integer; const encode: TEncoding): boolean;

  function doResponse(ssRst: TStringStream): integer;
  var
    lResponse: IHTTPResponse;
  begin
    Result := 0;
    lResponse := nil;
    try
      try
        if SameText(method, sHTTPMethodPost) then begin
          if ob is TMultipartFormData then begin
            //lHttp.ContentType := 'multipart/form-data';
            //ShowSysLog('postGet: data TMultipartFormData, size ' + IntToStr((TMultipartFormData(ob)).Stream.Size));
            lResponse := self.Post(Url, TMultipartFormData(ob), ssRst);
          end else if ob is TStringStream then begin
            TStringStream(ob).Position := 0;
            //ShowSysLog('postGet: data TStringStream, ' + (TStringStream(ob)).DataString);
            self.ContentType := 'application/json';
            lResponse := self.Post(Url, TStringStream(ob), ssRst);
          end else if ob is TStream then begin
            //ShowSysLog('postGet: data TStream, size ' + IntToStr((TStream(ob)).Size));
            lResponse := self.Post(Url, TStream(ob), ssRst);
          end else if ob is TStrings then begin
            //ShowSysLog('postGet: data TStrings, ' + (TStrings(ob)).Text);
            lResponse := self.Post(Url, TStrings(ob), ssRst);
          end else begin
            raise Exception.Create('Error: ' + ob.ClassName + ' not support.');
          end;
        end else if SameText(method, sHTTPMethodGet) then begin
          if not Assigned(ob) then begin
            lResponse := self.get(Url, ssRst);
          end else begin
            if ob is TStream then begin
              lResponse := self.get(Url, ssRst);
            end else begin
              raise Exception.Create('Error: ' + ob.ClassName + ' not support.');
            end;
          end;
        end;
//        while not FOK do begin
//          Sleep(0);
//          Application.ProcessMessages;
//        end;
      except
        on E: Exception do begin
          raise Exception.create(e.message);
        end;
      end;
    finally
//      if Assigned(lResponse) then begin
//        Result := lResponse.statusCode;
//      end;
    end;
  end;

  function getType(): string;
  begin
    if ob=nil then begin
      Result := 'none';
    end else begin
      Result := ob.ClassName + '->' + ob.ToString;
    end;
  end;

const FMT_BEGIN = '%s, %s, %s';
const FMT_END = '%s, %s, %s, result(%s)';

var
  statusCode: integer;
begin
  Result := '';
  ShowSysLog(method + ': begin, ' + format(FMT_BEGIN, [url, method, getType()]));
  ssRst := TStringStream.Create('', encode);
  //
  self.ConnectionTimeout := tmConn; // 10秒
  self.ResponseTimeout := tmRes;
  // add cookie
  self.CookieManager.AddServerCookie(
    //'ACCESS_TICKET="TGT-171-O42vP4LGehJ3z3VGOXPteuccJWdxBvSDTa1bUlSX1VT2miqnKM-cas.ecarpo.com"',
    THttpAsUtils.fCookie,
    url);
  statusCode := doResponse(ssRst);
  if ( statusCode = 200 ) then begin
    Result := ssRst.DataString;
    //cookieS := lHttp.CookieManager.CookieHeaders(TURI.Create(url));
  end;
  ShowSysLog(method + ': end, ' + format(FMT_END, [url, method, getType(), Result]));
end;

end.

