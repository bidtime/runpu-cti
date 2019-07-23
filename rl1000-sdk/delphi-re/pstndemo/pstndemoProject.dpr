program pstndemoProject;

uses
  Forms,
  pstndemo in 'pstndemo.pas' {Form1},
  channeldata in 'channeldata.pas' {$R *.res},
  brichiperr in 'sdk\brichiperr.pas',
  uEventTypeMap in 'uEventTypeMap.pas',
  uChannelCmd in 'uChannelCmd.pas',
  uCharComm in 'uCharComm.pas',
  brisdklib in 'sdk\llj\brisdklib.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook<>0;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
