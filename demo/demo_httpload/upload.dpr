program upload;

uses
  Vcl.Forms,
  uHttpUtils in '..\..\common\src\utils\uHttpUtils.pas',
  uCallRecordDTO in '..\..\common\src\dto\uCallRecordDTO.pas',
  uFileRecUtils in '..\..\rl1000-sdk\delphi-xe\ccgate\src\utils\uFileRecUtils.pas',
  uUploadDTO in '..\..\common\src\dto\uUploadDTO.pas',
  uFileDataPost in '..\..\common\src\utils\uFileDataPost.pas',
  uCmdEvent in '..\..\rl1000-sdk\delphi-xe\ccgate\src\cmd\com\uCmdEvent.pas',
  uJsonSUtils in '..\..\common\src\utils\uJsonSUtils.pas',
  uPhoneConfig in '..\..\rl1000-sdk\delphi-xe\ccgate\src\call\uPhoneConfig.pas',
  uFrmMain in 'uFrmMain.pas' {frmMain},
  uJsonFUtils in '..\..\common\src\utils\uJsonFUtils.pas',
  uShowMsgBase in '..\..\rl1000-sdk\delphi-xe\ccgate\src\utils\uShowMsgBase.pas',
  uFormatMsg in '..\..\rl1000-sdk\delphi-xe\ccgate\src\utils\uFormatMsg.pas',
  brisdklib in '..\..\rl1000-sdk\delphi-xe\ccgate\src\sdk\llj\brisdklib.pas',
  uLog4me in '..\..\common\src\utils\uLog4me.pas',
  uFileUtils in '..\..\common\src\utils\uFileUtils.pas',
  uRecInf in '..\..\common\src\utils\uRecInf.pas',
  uComObj in '..\..\rl1000-sdk\delphi-xe\ccgate\src\utils\uComObj.pas',
  uDateTimeUtils in '..\..\rl1000-sdk\delphi-xe\ccgate\src\utils\uDateTimeUtils.pas',
  uTimeUtils in '..\..\rl1000-sdk\delphi-xe\ccgate\src\utils\uTimeUtils.pas',
  uLocalRemoteCallEv in '..\..\rl1000-sdk\delphi-xe\ccgate\src\call\uLocalRemoteCallEv.pas',
  uFrmUrlParam in 'uFrmUrlParam.pas' {frameUrlParam: TFrame};

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := DebugHook<>0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.




