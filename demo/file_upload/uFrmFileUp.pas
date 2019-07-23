unit uFrmFileUp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  IniFiles, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type

  TForm1 = class(TForm)
    Edit1: TEdit;
    btnStart: TButton;
    ProgressBar1: TProgressBar;
    lblState: TLabel;
    Edit2: TEdit;
    btnCheckDl: TButton;
    Memo1: TMemo;
    NetHTTPClient1: TNetHTTPClient;
    btnUnzip: TButton;
    btnZip: TButton;
    btnFileAge: TButton;
    btnRemove: TButton;
    Button1: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCheckDlClick(Sender: TObject);
    procedure btnUnzipClick(Sender: TObject);
    procedure btnZipClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
  private
    FAllowFormClose: Boolean;
    { Private declarations }
    procedure OnReceiveData(const Sender: TObject; AContentLength: Int64;
      AReadCount: Int64; var Abort: Boolean);
    procedure download(const url: string; const sub: string);
    procedure showLog(const S: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  Form1: TForm1;

implementation

uses uJsonSUtils, uSimpleHttp, uUpgradeInfo, zip;

{$R *.dfm}

{ TForm1 }

procedure TForm1.download(const url: string; const sub: string);

  procedure dl2();
  var u: TUpgradeInfo;
    f: string;
  begin
    u := TUpgradeHelper.dl(self.Edit2.text);
    if u.download then begin
      f := GetCurrentDir() + '\dl\1.zip';
      DeleteFile(PChar(f));
      if (THttpHelper.save(u.dl_url, f, 10 * 1000,
        60 * 60 * 1000, OnReceiveData)) then begin

      end;
    end;
  end;

begin
  lblState.Caption := '准备下载...';
  ProgressBar1.Position := 0;
  btnStart.Enabled := False;
  //开始不允许关闭窗体
  FAllowFormClose := False;
  try
    dl2();
  finally
    //最终都允许关闭窗体
    btnStart.Enabled := True;
    FAllowFormClose := True;
  end;
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  download(self.edit1.text, GetCurrentDir());
end;

procedure TForm1.btnCheckDlClick(Sender: TObject);
var u: TUpgradeInfo;
begin
  u := TUpgradeHelper.dl(self.Edit2.text);
  if u.download then begin
    showLog('need download, cur verNo ' + u.info);
    showLog('url:' + u.dl_url);
    self.Edit1.Text := u.dl_url;
  end else begin
    showLog('do not download');
  end;
end;

procedure TForm1.btnUnzipClick(Sender: TObject);
begin
//  TZipFile.ExtractZipFile(
//    'D:\working\phone_box\runpu\runpu-cti\demo\file_upload\Win32\Debug\file_up\fileupload.zip'
//      ,'D:\working\phone_box\runpu\runpu-cti\demo\file_upload\Win32\Debug\file_up\1'
//        , nil);
  TZipFile.ExtractZipFile(
    GetCurrentDir() + '\file_up\fileupload.zip'
      , GetCurrentDir() + '\tmp'
        , nil);
end;

procedure TForm1.btnZipClick(Sender: TObject);
begin
//  TZipFile.ZipDirectoryContents(
//    'D:\working\phone_box\runpu\runpu-cti\demo\file_upload\Win32\Debug\fileupload.exe',
//      'D:\working\phone_box\runpu\runpu-cti\demo\file_upload\Win32\Debug\file_up\fileupload.zip');
end;

procedure TForm1.btnRemoveClick(Sender: TObject);
var old, new: string;
begin
  old := 'D:\working\phone_box\runpu\runpu-cti\demo\file_upload\Win32\Debug\file_up\fileupload.exe';
  new := 'D:\working\phone_box\runpu\runpu-cti\demo\file_upload\Win32\Debug\fileupload.exe';
  ShowMessage(BoolToStr(RenameFile(old, new), true));
end;

constructor TForm1.create(AOwner: TComponent);
begin
  inherited;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FAllowFormClose;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  btnStart.Enabled := True;
  FAllowFormClose := True;
  //ProgressBar1.Position := 0;
end;

procedure TForm1.OnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var Abort: Boolean);
begin
  //加上这句界面不卡死.
  Application.ProcessMessages;
  ProgressBar1.Max := AContentLength;
  ProgressBar1.Position := AReadCount;
  lblState.Caption := '下载中...';
end;

procedure TForm1.showLog(const S: string);
begin
  self.Memo1.Lines.Add(S);
end;

end.
