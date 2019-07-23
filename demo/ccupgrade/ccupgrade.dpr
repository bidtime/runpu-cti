program ccupgrade;

uses
  Vcl.Forms,
  uUpgradeInfo in '..\..\common\src\utils\uUpgradeInfo.pas',
  uSimpleHttp in '..\..\common\src\utils\uSimpleHttp.pas',
  uFrmDownload in 'uFrmDownload.pas' {frmDownload},
  uJsonSUtils in '..\..\common\src\utils\uJsonSUtils.pas',
  uLog4me in '..\..\common\src\utils\uLog4me.pas',
  uFileUtils in '..\..\common\src\utils\uFileUtils.pas',
  uRecInf in '..\..\common\src\utils\uRecInf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDownload, frmDownload);
  Application.Run;
end.














