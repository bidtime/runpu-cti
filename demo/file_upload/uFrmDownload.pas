unit uFrmDownload;

interface

uses
  Winapi.Windows, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, System.Classes, Vcl.Forms;

type
  TfrmDownload = class(TForm)
    GroupBox1: TGroupBox;
    ProgressBar1: TProgressBar;
    btnDownload: TButton;
    btnCancel: TButton;
    lblState: TLabel;
    procedure btnDownloadClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAllowFormClose: Boolean;
    FAbortedProcess: boolean;
    procedure OnReceiveData(const Sender: TObject; AContentLength: Int64;
      AReadCount: Int64; var Abort: Boolean);
  public
    { Public declarations }
  end;

var
  frmDownload: TfrmDownload;

implementation

uses uSimpleHttp, uUpgradeInfo, SysUtils, zip;

{$R *.dfm}

procedure TfrmDownload.btnDownloadClick(Sender: TObject);

  procedure unzip(const fZip: string);
  begin
    try
      TZipFile.ExtractZipFile(fZip, getCurrentDir(), nil);
    except
      on e: Exception do begin
        lblState.Caption := '解压失败: ' + e.Message;
      end;
    end;
  end;

  function getUrl(): string;
  var url: string;
  begin
    //ShowMessage(ParamStr(1) + ' ' + ParamStr(2));
    url := TUpgradeHelper.setVerNo( ParamStr(1), ParamStr(2) );
    //ShowMessage(url);
    Result := url;
  end;

  procedure downlad2();
  //const DL_NAME = '';//http://172.16.200.225:81/file_up/upgrade.inf1?verNo=0.01';
  var u: TUpgradeInfo;
    fZip: string;
    dl_url: string;
  begin
    try
      dl_url := getUrl();
      //ShowMessage(dl_url);
      u := TUpgradeHelper.dl(dl_url);
    except
      on e: Exception do begin
        lblState.Caption := '升级失败: ' + e.Message;
        exit;
      end;
    end;
    try
      if Assigned(u) then begin
        if u.download then begin
          fZip := GetCurrentDir() + '\upgrade\1.zip';
          DeleteFile(PChar(fZip));
          if (THttpHelper.save(u.dl_url, fZip, 10 * 1000,
              60 * 60 * 1000, OnReceiveData)) then begin
            unzip(fZip);
          end;
          //DeleteFile(fZip);
        end else begin
          lblState.Caption := '无需升级';
        end;
      end else begin
        lblState.Caption := '升级失败';
      end;
    finally
      if Assigned(u) then begin
        u.Free;
      end;
    end;
  end;

begin
  lblState.Caption := '准备下载...';
  ProgressBar1.Position := 0;
  //开始不允许关闭窗体
  FAllowFormClose := False;
  btnDownload.Enabled := False;
  FAbortedProcess := false;
  self.btnCancel.Enabled := true;
  try
    Application.ProcessMessages;
    Sleep(100);
    downlad2();
  finally
    //最终都允许关闭窗体
    btnDownload.Enabled := True;
    FAllowFormClose := True;
    self.btnCancel.Enabled := false;
  end;
end;

procedure TfrmDownload.btnCancelClick(Sender: TObject);
begin
  FAbortedProcess := true;
end;

procedure TfrmDownload.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FAllowFormClose;
end;

procedure TfrmDownload.FormCreate(Sender: TObject);
begin
  FAllowFormClose := true;
  self.btnCancel.Enabled := false;
end;

procedure TfrmDownload.OnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var Abort: Boolean);

  function getFinishFlag(): string;
  begin
    if (AContentLength = AReadCount) then begin
      Result := '下载完成.';
    end else begin
      Result := '下载中...';
    end;
  end;

begin
  //加上这句界面不卡死.
  Abort := FAbortedProcess;
  Application.ProcessMessages;
  if (ProgressBar1.Max <> AContentLength) then begin
    ProgressBar1.Max := AContentLength;
  end;
  ProgressBar1.Position := AReadCount;
  lblState.Caption := getFinishFlag();
  Application.ProcessMessages;
  //lblState.Caption := '下载中...' + Format('%.0f', [ (AReadCount/AContentLength) * 100 ]) + '%';
end;

//  function unzip(const f: string): boolean;
//  var dst: string;
//  begin
//    dst := GetCurrentDir() + '\dl\upgrade';
//    if DirectoryExists(dst) then begin
//      RmDir(dst);
//    end else begin
//      ForceDirectories(dst);
//    end;
//    TZipFile.ExtractZipFile(f, dst, nil);
//    Result := true;
//  end;

end.
