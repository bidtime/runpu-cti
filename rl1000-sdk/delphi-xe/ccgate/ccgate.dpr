program ccgate;

uses
  Forms,
  Windows,
  WinSvc,
  SvcMgr,
  SysUtils,
  brichiperr in 'src\sdk\brichiperr.pas',
  channeldata in 'src\utils\channeldata.pas',
  uFormatMsg in 'src\utils\uFormatMsg.pas',
  uPhoneRecFileAuto in 'src\rec\uPhoneRecFileAuto.pas',
  uProcessPhoneMsg in 'src\rec\uProcessPhoneMsg.pas',
  uPhoneConfig in 'src\call\uPhoneConfig.pas',
  uCallManager in 'src\call\uCallManager.pas',
  uPhoneCfgMsgBase in 'src\call\uPhoneCfgMsgBase.pas',
  uLocalRemoteCallEv in 'src\call\uLocalRemoteCallEv.pas',
  uCallManagerBase in 'src\call\uCallManagerBase.pas',
  uFrmSetting in 'src\frm\uFrmSetting.pas' {frmSetting},
  uFrmMain in 'src\srv\uFrmMain.pas' {frmMain},
  uHttpServerBase in 'src\srv\WebSockets\uHttpServerBase.pas',
  uMyHttpServer in 'src\srv\WebSockets\uMyHttpServer.pas',
  uFrmIntro in 'src\frm\uFrmIntro.pas' {frmIntro},
  uFrameProp in 'src\view\frame\uFrameProp.pas' {FrameProp: TFrame},
  uShowMsgBase in 'src\utils\uShowMsgBase.pas',
  uCmdBoolean in 'src\cmd\req\uCmdBoolean.pas',
  uResultDTO in 'src\cmd\res\uResultDTO.pas',
  uCmdDialup in 'src\cmd\req\uCmdDialup.pas',
  uCmdComm in 'src\cmd\req\uCmdComm.pas',
  uCmdType in 'src\cmd\com\uCmdType.pas',
  uCmdException in 'src\except\uCmdException.pas',
  uAppConst in 'src\com\uAppConst.pas',
  uInstanceService in 'src\com\uInstanceService.pas',
  uCmdParser in 'src\cmd\req\uCmdParser.pas',
  uCmdEvent in 'src\cmd\com\uCmdEvent.pas',
  uCharComm in 'src\utils\uCharComm.pas',
  uCmdResponse in 'src\cmd\uCmdResponse.pas',
  uEventTypeMap in 'src\call\uEventTypeMap.pas',
  uFileRecUtils in 'src\utils\uFileRecUtils.pas',
  uCallRecordDTO in '..\..\..\common\src\dto\uCallRecordDTO.pas',
  uUploadDTO in '..\..\..\common\src\dto\uUploadDTO.pas',
  uJsonSUtils in '..\..\..\common\src\utils\uJsonSUtils.pas',
  uFileDataPost in '..\..\..\common\src\utils\uFileDataPost.pas',
  uCmdPhone in 'src\cmd\req\uCmdPhone.pas',
  uCmdCookie in 'src\cmd\req\uCmdCookie.pas',
  uComObj in 'src\utils\uComObj.pas',
  uJsonFUtils in '..\..\..\common\src\utils\uJsonFUtils.pas',
  uHttpUtils in '..\..\..\common\src\utils\uHttpUtils.pas',
  uDateTimeUtils in 'src\utils\uDateTimeUtils.pas',
  uChannelCmd in 'src\sdk\uChannelCmd.pas',
  uTimeUtils in 'src\utils\uTimeUtils.pas',
  uFileUtils in '..\..\..\common\src\utils\uFileUtils.pas',
  uVerInfo in '..\..\..\common\src\utils\uVerInfo.pas',
  uSimpleHttp in '..\..\..\common\src\utils\uSimpleHttp.pas',
  uUpgradeInfo in '..\..\..\common\src\utils\uUpgradeInfo.pas',
  uUpgradeTimer in '..\..\..\common\src\utils\uUpgradeTimer.pas',
  uLog4me in '..\..\..\common\src\utils\uLog4me.pas',
  uRecInf in '..\..\..\common\src\utils\uRecInf.pas',
  brisdklib in 'src\sdk\llj\brisdklib.pas',
  uRegUtils in 'src\utils\uRegUtils.pas',
  uDiskUtils in 'src\utils\uDiskUtils.pas',
  uPhoneRecFile in 'src\rec\uPhoneRecFile.pas',
  uLogFile in '..\..\..\common\src\utils\uLogFile.pas',
  uLogFileU in '..\..\..\common\src\utils\uLogFileU.pas',
  uHttpException in 'src\utils\uHttpException.pas',
  uHttpResultDTO in 'src\utils\uHttpResultDTO.pas',
  uFileStrsProcess in 'src\utils\uFileStrsProcess.pas',
  uFrameMemo in 'src\view\frame\uFrameMemo.pas' {frameMemo: TFrame},
  uQueueBase in 'src\view\frame\uQueueBase.pas',
  uFrmAboutBox in 'src\frm\uFrmAboutBox.pas' {FrmAboutBox},
  uQueueManager in 'src\view\frame\uQueueManager.pas';

{$R *.res}

function Installing: Boolean;
begin
  Result := FindCmdLineSwitch('INSTALL',['-','\','/'], True) or
            FindCmdLineSwitch('UNINSTALL',['-','\','/'], True);
end;

function StartService: Boolean;
var
  Mgr, Svc: Integer;
  UserName, ServiceStartName: string;
  Config: Pointer;
  Size: DWord;
begin
  Result := False;
  Mgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if Mgr <> 0 then begin
    Svc := OpenService(Mgr, PChar(SServiceName), SERVICE_ALL_ACCESS);
    Result := Svc <> 0;
    if Result then begin
      QueryServiceConfig(Svc, nil, 0, Size);
      Config := AllocMem(Size);
      try
        QueryServiceConfig(Svc, Config, Size, Size);
        ServiceStartName := PQueryServiceConfig(Config)^.lpServiceStartName;
        if CompareText(ServiceStartName, 'LocalSystem') = 0 then
          ServiceStartName := 'SYSTEM';
      finally
        Dispose(Config);
      end;
      CloseServiceHandle(Svc);
    end;
    CloseServiceHandle(Mgr);
  end;
  if Result then begin
    Size := 256;
    SetLength(UserName, Size);
    GetUserName(PChar(UserName), Size);
    SetLength(UserName, StrLen(PChar(UserName)));
    Result := CompareText(UserName, ServiceStartName) = 0;
  end;
end;

begin
  //ReportMemoryLeaksOnShutdown := DebugHook<>0;
  if not Installing then begin
    CreateMutex(nil, True, 'CCGATE_SERVER_0.1');
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      MessageBox(0, PChar(SAlreadyRunning), SApplicationName, MB_ICONERROR);
      Halt;
    end;
  end;
  if Installing or StartService then begin
    SvcMgr.Application.Initialize;
    g_InstanceService := TInstanceService.CreateNew(SvcMgr.Application, 0);
    SvcMgr.Application.CreateForm(TFrmMain, FrmMain);
  SvcMgr.Application.Run;
  end else begin
    Forms.Application.MainFormOnTaskbar := false;
    Forms.Application.ShowMainForm := False;
    Forms.Application.Initialize;
    Forms.Application.CreateForm(TFrmMain, FrmMain);
    FrmMain.Initialize(False);
    Forms.Application.Run;
  end;
end.
















