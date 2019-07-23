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
    cbxForce: TCheckBox;
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

uses uSimpleHttp, uUpgradeInfo, SysUtils, uLog4me, zip, IOUtils, uRecInf, uFileUtils;//, Dialogs;

{$R *.dfm}

procedure TfrmDownload.btnDownloadClick(Sender: TObject);

  function unzip(const fZip, dst: string): boolean;
  begin
    Result := false;
    try
      TDirectory.CreateDirectory(dst);
      //ForceDirectories(dst);
      TZipFile.ExtractZipFile(fZip, dst, nil);
      Result := true;
      //ShowMessage('success.');
    except
      on e: Exception do begin
        lblState.Caption := '解压失败: ' + e.Message;
      end;
    end;
  end;

  function getUrl(): string;
  //const DL_NAME = 'http://172.16.200.225:81/file_up/upgrade.inf?verNo=0.01';
  var url: string;
  begin
    //ShowMessage(ParamStr(1) + ' ' + ParamStr(2));
    //url := DL_NAME;
    url := TUpgradeHelper.setVerNo( ParamStr(1), ParamStr(2) );
    //ShowMessage(url);
    Result := url;
  end;

  {function complete(const upgradePath, curDir: string): UINT;
  var cmd: string;
  begin
    //winexec( 'xcopy d:\test e:\ /s/e', false);
    cmd := format('xcopy %s %s /s/e', [upgradePath, curDir]);
    //Application.Terminate;
    Result := winexec( PAnsichar(cmd), 0 );
    lblState.Caption := 'winexce: retcode=' + IntToStr(Result);
  end;}

  {procedure complete(const upgradePath, curDir: string);
  var path, par: string;
  begin
    par := format('%s %s', [upgradePath, curDir]);
    path := 'xcopy';//GetCurrentDir() + '\ccupgrade.exe';
    Application.Terminate;
    //Sleep(100);
    ShellExecute(0, 'Open', pchar(path), pchar(par), nil, SW_SHOWNORMAL);
    //ShellExecute(Handle, 'Open', Pchar(Application.ExeName),nil,nil,SW_SHOWNORMAL);
    //halt;
  end;}

  procedure complete(const upgradePath, curDir: string);
  begin
    //TDirectory.Move(upgradePath, curDir);
    TFileUtils._removeDir(upgradePath, curDir);
    lblState.Caption := '升级成功';
  end;

  procedure downlad2();
  var u: TUpgradeInfo;
    fZip, fDstPath: string;
    dl_url: string;
    label DOWNLOAD;
  begin
    try
      dl_url := getUrl();
      //ShowMessage(dl_url);
      u := TUpgradeHelper.dl(dl_url);
    except
      on e: Exception do begin
        lblState.Caption := '升级失败: ' + e.Message;
        log4error(lblState.Caption);
        exit;
      end;
    end;
    try
      if Assigned(u) then begin
        if u.download then begin
DOWNLOAD:
          //fZip := GetCurrentDir() + '\upgrade\dl\1.zip';
          //fDstPath := GetCurrentDir() + '\upgrade\repack';
          fZip := TFileUtils.appFile([TRecInf.UPGRADE, 'dl', '1.zip']);
          fDstPath := TFileUtils.appDir([TRecInf.UPGRADE, TRecInf.REPACK]);
          if TFile.Exists(fZip) then begin
            TFile.Delete(fZip);
          end;
          if not TDirectory.Exists(fDstPath) then begin
            TDirectory.CreateDirectory(fDstPath);
          end else begin
            TDirectory.Delete(fDstPath, true);
          end;
          //TFileUtils.DeletePath(fDstPath);
          //
          if (THttpHelper.save(u.dl_url, fZip, 10 * 1000,
              60 * 60 * 1000, OnReceiveData)) then begin
            if unzip(fZip, fDstPath) then begin
              complete(fDstPath, GetCurrentDir());
            end;
          end;
          //DeleteFile(fZip);
        end else begin
          lblState.Caption := '无需升级';
          if self.cbxForce.Checked then begin
            goto DOWNLOAD;
          end;
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
  log4debug('准备下载...');
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
