unit uVerInfo;

interface

const
  CompanyName = '北京运通集团';
  TelInfo1 = '400-045-6699';
  TelInfo2 = '010-86186688';
  WebAddress = 'http://erp.yuntong.com';
  Version = 0.35;
  Build = '2019.07.22';
  AppExt = '服务';
  AppName = '运通电话盒子网关(L)';

  procedure openDownloadWindow(const bShowQ: boolean);
  function isNeedDl(): boolean;
  procedure autoDl();
  //function isTryNeedDl(var bShowQuery: boolean): boolean;
  function getUpgradeInfo(): string;
  function getAppInfo: string;
  function getVerInfo: string;

implementation

uses ShellApi, uPhoneConfig, SysUtils, Forms, Windows, uUpgradeInfo, uFileUtils,
  uRecInf, IOUtils;

function getAppInfo: string;
begin
  Result := AppName + ' ' +
    AppExt + ' ' +
    '版本：' + FloatToStr(Version) +
    '(build ' + Build + ')'
    ;
end;

function getVerInfo: string;
begin
  Result := 'ver:' + FloatToStr(Version) + '(' + Build + ')';
end;

function isNeedDl(): boolean;
var url: string;
begin
  url := TUpgradeHelper.setVerNo( g_phoneConfig.upgradeURL, Version );
  Result := TUpgradeHelper.isUpgrade(url);
end;

function getUpgradeInfo(): string;
var url: string;
  u: TUpgradeInfo;
begin
  Result := '';
  url := TUpgradeHelper.setVerNo( g_phoneConfig.upgradeURL, Version );
  u := TUpgradeHelper.dl_slient(url);
  try
    if Assigned(u) then begin
      if u.download then begin
        Result := u.info;
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

const APP_UPGRADE = 'ccupgrade.exe';

procedure autoDl();

  procedure autoRestoreUpgradeApp();
  var fSrcPath, fDstPath: string;
  begin
    try
      fSrcPath := TFileUtils.appFile([TRecInf.UPGRADE, TRecInf.REPACK, APP_UPGRADE]);
      if TFile.Exists(fSrcPath) then begin
        fDstPath := TFileUtils.appFile(APP_UPGRADE);
        if TFile.Exists(fDstPath) then begin
          TFile.Delete(fDstPath);
        end;
        TFile.Move(fSrcPath, fDstPath);
      end;
    except
      on e: Exception do begin
      end;
    end;
  end;

  function isTryNeedDl(var bShowQuery: boolean): boolean;
  begin
    Result := isNeedDl();
    if not Result then begin
      if MessageBox(0, '程序已经最新, 确定需要升级?', '信息', MB_ICONQUESTION + MB_YESNO) = IDYES then begin
        bShowQuery := true;
        Result := true;
      end;
    end;
  end;

var bShowQuery: boolean;
begin
  autoRestoreUpgradeApp();
  if isTryNeedDl(bShowQuery) then begin
    openDownloadWindow(bShowQuery);
  end;
end;

procedure openDownloadWindow(const bShowQ: boolean);
var path, par: string;
begin
  par := format('%s %f', [g_phoneConfig.upgradeURL, Version]);
  path := TFileUtils.appFile(APP_UPGRADE);
  if not TFile.Exists(path) then begin
    MessageBox(0, '升级程序不存在, 无法升级.', '信息', MB_ICONINFORMATION + MB_Ok);
    exit;
  end else begin
    if (not bShowQ) then begin
      if MessageBox(0, '检测到有新版本，确定是否需要升级?', '信息', MB_ICONQUESTION + MB_YESNO) <> IDYES then begin
        exit;
      end;
    end;
  end;
  Application.Terminate;
  Sleep(100);
  ShellExecute(0, 'Open', pchar(path), pchar(par), nil, SW_SHOWNORMAL);
  //ShellExecute(Handle, 'Open', Pchar(Application.ExeName),nil,nil,SW_SHOWNORMAL);
  //halt;
end;

end.
