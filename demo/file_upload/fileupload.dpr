program fileupload;

uses
  Vcl.Forms,
  uJsonSUtils in '..\..\common\src\utils\uJsonSUtils.pas',
  uUpgradeInfo in '..\..\common\src\utils\uUpgradeInfo.pas',
  uSimpleHttp in '..\..\common\src\utils\uSimpleHttp.pas',
  uZipUtils in 'uZipUtils.pas',
  uFrmDownload in 'uFrmDownload.pas' {frmDownload};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDownload, frmDownload);
  Application.Run;
end.
