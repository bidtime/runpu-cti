unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.StdCtrls,
  Vcl.ExtCtrls, IdBaseComponent, IdCookieManager, Vcl.ComCtrls, uFrmUrlParam;

type
  TfrmMain = class(TForm)
    NetHTTPClient1: TNetHTTPClient;
    memoResult: TMemo;
    GroupBox1: TGroupBox;
    btnWavJson: TButton;
    NetHTTPRequest1: TNetHTTPRequest;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    memoCookie: TMemo;
    Label6: TLabel;
    Button7: TButton;
    frameUrlParam1: TframeUrlParam;
    frameUrlParam2: TframeUrlParam;
    frameUrlParam3: TframeUrlParam;
    frameUrlParam4: TframeUrlParam;
    TabSheet6: TTabSheet;
    frameUrlParam5: TframeUrlParam;
    procedure Button1Click(Sender: TObject);
    procedure btnWavJsonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure frameUrlParam5Button2Click(Sender: TObject);
    procedure frameUrlParam1Button2Click(Sender: TObject);
    procedure frameUrlParam2Button2Click(Sender: TObject);
    procedure frameUrlParam3Button2Click(Sender: TObject);
    procedure frameUrlParam4Button2Click(Sender: TObject);
  private
    function post(const url, ctx: string): string;
    function upload(const url, fName: string): string;
    procedure addResult(const s: string; const clear: boolean=false); overload;
  protected
    procedure addResult(const k, v: string; const clear: boolean=false); overload;
    {procedure upload(const url, fileName: string);
    procedure upload3(const url, fileName: string);
    function SendFile1(const Url, FileName: String): Boolean;
    function SendFile2(const Url, FileName: String): Boolean;
    function SendFile(const Url, FileName: String;
      const tmConn: integer; const tmRes: integer): string;}
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses System.Net.mime, StrUtils, uFileRecUtils, uLocalRemoteCallEv, uJsonFUtils,
  uFileDataPost, uHttpUtils, uRecInf, uCallRecordDTO; //, uUploadDTO

{$R *.dfm}

const ONE_SECOND = 1000;

  function toStrHit1(const a: string; const c: char=#13): string;
  var i: integer;
    t: char;
  begin
    Result := '';
    for I := 1 to Length(a) do begin
      t := a[i];
      if t=c then begin
        break;
      end else begin
        Result := Result + t;
      end;
    end;
  end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
end;

{procedure TfrmMain.upload3(const url, fileName: string);
var
  Source: TMultipartFormData;
  ResponseContent: TMemoryStream;
  Encoding: TEncoding;
begin
  // アクセスするURL
  //URL := 'http://test2.localhost/index.php';
  // 送信するデータ
  Source := TMultipartFormData.Create;
  Source.AddField('file', fileName);
  // 取得したデータを格納するStream
  ResponseContent := TMemoryStream.Create;
  // 取得したデータのエンコーディング
  Encoding := TEncoding.UTF8;
  // URLにアクセスして、取得したデータをResponseContentに格納する
  self.NetHTTPClient1.Post(URL, Source, ResponseContent);
  // 取得したデータをMemoコンポーネントに表示する
  memoResult.Lines.LoadFromStream(ResponseContent, Encoding);
end;}

{function TfrmMain.SendFile(Const url, fileName: String;
  const tmConn: integer; const tmRes: integer): string;

  function http_post(const multFormData: TMultipartFormData): string;
  var
    lHttp: THTTPClient;
    lResponse: IHTTPResponse;
    strs: TStringStream;
  begin
    Result := '';
    strs := TStringStream.Create('', TEncoding.UTF8);
    lHttp := THTTPClient.Create;
    try
      //
      lHttp.ConnectionTimeout := tmConn; // 10秒
      lHttp.ResponseTimeout := tmRes;
      lHttp.AcceptCharSet := 'utf-8';
      lHttp.AcceptEncoding := 'utf-8';
      lHttp.AcceptLanguage := 'zh-CN';
      lHttp.ContentType := 'multipart/form-data';
      lHttp.UserAgent := 'Embarcadero URI Client/1.0';
      try
        lResponse := lHttp.Post(Url, multFormData, strs);
      except
        on E: Exception do begin
          raise e;
        end;
      end;
      if ( lResponse.StatusCode = 200 ) then begin
        Result := strs.DataString;
      end;
    finally
      lHttp.Free;
      strs.Free;
    end;
  end;

var
 multFormData: TMultipartFormData;
begin
  multFormData := TMultipartFormData.Create;
  try
    multFormData.AddFile('file', FileName);
    Result := http_post(multFormData);
  finally
    multFormData.Free;
  end;
end;}

procedure TfrmMain.addResult(const s: string; const clear: boolean);
begin
  if clear then begin
    Self.memoResult.clear;
  end;
  Self.memoResult.Lines.Add(s);
end;

procedure TfrmMain.addResult(const k, v: string; const clear: boolean);
begin
  addResult(k + ':' + v);
end;

function TfrmMain.post(const url, ctx: string): string;
var ret: string;
begin
  try
    addResult('url: ' + url);
    addResult('ctx: ' + ctx);
    try
      ret := THttpUtils.postJson(url, ctx,
        2 * ONE_SECOND, 2 * 60 * ONE_SECOND);
      addResult('rst: ' + ret );
      Result := ret;
    except
      on E: Exception do begin
        ShowMessage(e.Message);
        //raise Exception.create(e.message);
      end;
    end;
    addResult('');
  finally
  end;
end;

function TfrmMain.upload(const url, fName: string): string;
var ret: string;
begin
  try
    addResult('url: ' + url);
    addResult('fname: ' + fName);
    try
      ret := THttpUtils.upload(url, fName,
        5 * ONE_SECOND, 5 * 60 * ONE_SECOND);
      addResult('rst: ' + ret );
      Result := ret;
    except
      on E: Exception do begin
        ShowMessage(e.Message);
        //raise Exception.create(e.message);
      end;
    end;
    addResult('');
  finally
  end;
end;

procedure TfrmMain.btnWavJsonClick(Sender: TObject);

  function getInfo(const fName: string): string;
  var u: TLocalRemoteCallEv;
  begin
    u := TLocalRemoteCallEv.Create();
    try
      u.getTestInfo();
      //r := r;
//        u.fileKey := r.data.url;
//        u.fileName := r.data.name;
//        u.fileSize := r.data.size;
      TJsonFUtils.SerializeF(u, fName);
      Result := '';
    finally
      u.Free;
    end;
  end;

//var
//  edtFileName, fResFile: string;
//  fJsonFile: string;
begin
  {edtFileName := toStrHit1(memoFileName.Lines.Text);
  if not FileExists(edtFileName) then begin
    exit;
  end;}

  {fResFile := TFileRecUtils.getDirOfRec(TRecInf.call) + ExtractFileName(edtFileName);
  if (TFileRecUtils.copy(edtFileName, fResFile, false)) then begin
    fJsonFile := ChangeFileExt(fResFile, '.json');
    getInfo(fJsonFile);
    //TFileRecUtils.saveToFile();
    g_FileDirProcess.addCurFileJson(fJsonFile);
  end;}
  //memoResult.Clear;
  //MakeFileList(memoCtx.Text, '.pas', memoResult.Lines);
end;

procedure TfrmMain.Button7Click(Sender: TObject);
begin
  THttpUtils.addCookie(self.memoCookie.Text);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
   function getInfo(const b: boolean): string;
    var u: TLocalRemoteCallEv;
    begin
      u := TLocalRemoteCallEv.Create();
      try
        u.resetVal(true);
        u.getTestInfo();
        //r := r;
        {u.fileKey := r.data.url;
        u.fileName := r.data.name;
        u.fileSize := r.data.size;}
        if b then begin
          Result := u.toStrs;
        end else begin
          Result := u.toJsonV;
        end;
      finally
        u.Free;
      end;
    end;
//var s: string;
begin
  self.frameUrlParam3.memoCtx.Text := getInfo(false);
  self.frameUrlParam4.memoCtx.Text := getInfo(true);
  {s := memoFileName.Text;
  if s.Chars[1] <> ':' then begin
    memoFileName.Text := getCurrentDir() + '\' + memoFileName.Text;
  end;
  //THttpUtils.addCookie('ACCESS_TICKET="TGT-171-O42vP4LGehJ3z3VGOXPteuccJWdxBvSDTa1bUlSX1VT2miqnKM-cas.ecarpo.com"');
  THttpUtils.addCookie(self.memoCookie.Text);
  //
  S := TFileRecUtils.getDirOfRec(TRecInf.CALL) + '1887DC15-488B-4D52-83D7-212818ADE62C.json';
  self.memoCtx.Lines.LoadFromFile(S);}
end;

procedure TfrmMain.frameUrlParam1Button2Click(Sender: TObject);
begin
  post(self.frameUrlParam1.edtUrl.Text, self.frameUrlParam1.memoCtx.Text);
end;

procedure TfrmMain.frameUrlParam2Button2Click(Sender: TObject);
begin
  post(self.frameUrlParam2.edtUrl.Text, self.frameUrlParam2.memoCtx.Text);
end;

procedure TfrmMain.frameUrlParam3Button2Click(Sender: TObject);
var json: string;
begin
  json := TCallRecordBase.transJson(self.frameUrlParam3.memoCtx.Text);
  post(self.frameUrlParam3.edtUrl.Text, json);
end;

procedure TfrmMain.frameUrlParam4Button2Click(Sender: TObject);
begin
  post(self.frameUrlParam4.edtUrl.Text, self.frameUrlParam4.memoCtx.Text);
end;

procedure TfrmMain.frameUrlParam5Button2Click(Sender: TObject);
var fName: string;
begin
  fName := self.frameUrlParam5.memoCtx.text;
  fName := fName.Replace(#10, '');
  fName := fName.Replace(#13, '');
  upload(self.frameUrlParam5.edtUrl.text, fName);
end;

//var strs: TStringStream;
//begin
//  strs := TStringStream.Create;
//  try
//    Self.memoResult.Lines.Add('');
//    strs.WriteString(memoCtx.Text);
//    Self.memoResult.Lines.Add( THttpUtils.post(self.edtUrl2.text, strs,
//      2 * ONE_SECOND, 60 * ONE_SECOND) );
//    Self.memoResult.Lines.Add('');
//  finally
//    strs.Free;
//  end;
//end;

{function TfrmMain.SendFile1(Const Url, FileName: String): Boolean;
const ONE_SECOND = 1000;
var
  lHttp: THTTPClient;
  lSendData: TMultipartFormData;
  lResponse: IHTTPResponse;
  strs: TStringStream;
begin
  strs := TStringStream.Create('', TEncoding.UTF8);
  lHttp := THTTPClient.Create;
  lSendData := TMultipartFormData.Create;
  try
    lSendData.AddFile('file', FileName);
    //
    lHttp.ConnectionTimeout := 10 * ONE_SECOND; // 10秒
    lHttp.ResponseTimeout := 60 * ONE_SECOND;   // 60秒
    lHttp.AcceptCharSet := 'utf-8';
    lHttp.AcceptEncoding := 'utf-8';
    lHttp.AcceptLanguage := 'zh-CN';
//    lHttp.ContentType := 'multipart/form-data';
    lHttp.UserAgent := 'Embarcadero URI Client/1.0';
    try
      lResponse := lHttp.Post(Url, lSendData, strs);
    except
      on E: Exception do begin
        raise e;
      end;
    end;
    Result := lResponse.StatusCode = 200;
    memoResult.Lines.Add(strs.DataString);
  finally
    lSendData.Free;
    lHttp.Free;
    strs.Free;
  end;
end;

function TfrmMain.SendFile2(Const Url, FileName: String): Boolean;
var
  lHttp: TNetHTTPClient;
  lSendData: TMultipartFormData;
  lResponse: IHTTPResponse;
  strs: TStringStream;
begin
  strs := TStringStream.Create('', TEncoding.UTF8);
  lHttp := TNetHTTPClient.Create(nil);
  lSendData := TMultipartFormData.Create;
  try
    lSendData.AddFile('file', FileName);
    lResponse := lHttp.Post(Url, lSendData, strs);
    Result := lResponse.StatusCode = 200;
    memoResult.Lines.Add(strs.DataString);
  finally
    lSendData.Free;
    lHttp.Free;
    strs.Free;
  end;
end;

procedure TfrmMain.upload(const url, fileName: string);
var
  cHttp: TNetHTTPClient;
  vData: TMultipartFormData;
  vRsp: TStringStream;
begin
  cHttp := TNetHTTPClient.Create(nil);
  vData := TMultipartFormData.Create;
  //vRsp := TStringStream.Create('', TEncoding.GetEncoding(65001));
  vRsp := TStringStream.Create('', TEncoding.UTF8);
  try
    vData.AddFile('file', fileName);
    with cHttp do begin
      ConnectionTimeout := 2000; // 2秒
      ResponseTimeout := 10000; // 10秒
      AcceptCharSet := 'utf-8';
      AcceptEncoding := 'utf-8';
      AcceptLanguage := 'zh-CN';
      ContentType := 'multipart/form-data';
      UserAgent := 'Embarcadero URI Client/1.0';
      try
        memoResult.Lines.Add('尝试上传文件 ' + fileName);
        Post(url, vData, vRsp);
        Application.ProcessMessages;
      except
        on E: Exception do
          // Error sending data: (12002) 操作超时.
          // Error receiving data: (12002) 操作超时
          if Copy(E.Message, 1, Pos(':', E.Message) - 1) = 'Error sending data' then begin
            memoResult.Lines.Add('Error:连接失败！')
          end else if Copy(E.Message, 1, Pos(':', E.Message) - 1) = 'Error receiving data' then begin
            memoResult.Lines.Add('Error:接收失败，请延长接收超时时间！')
          end else begin
            memoResult.Lines.Add('Error:' + E.Message);
          end;
      end;
      memoResult.Lines.Add(vRsp.DataString);
    end;
  finally
    cHttp.Free;
    vRsp.Free;
    vData.Free;
  end;
end;}

end.

