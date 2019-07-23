program jsontest;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {Form1},
  uCmdComm in 'uCmdComm.pas',
  uCmdBoolean in 'uCmdBoolean.pas',
  uResultDTO in 'uResultDTO.pas',
  uCmdResponse in 'uCmdResponse.pas',
  uJsonSUtils in 'uJsonSUtils.pas',
  uCmdDialup in 'uCmdDialup.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook<>0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.



