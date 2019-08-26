unit uLog4me;

interface

uses classes;

procedure  log4error(msg: AnsiString); //дERROR�������־
procedure  log4warn(msg: AnsiString); //дERROR�������־
procedure  log4info(msg: AnsiString); //дINFO�������־
procedure  log4debug(msg: AnsiString); //дDEBUG�������־

function  getLog4FileName(): AnsiString; //�õ���ǰ��־�ļ�ȫ��

procedure setLogLevel(const level: AnsiString);
function getLogLevel(): String;

implementation

uses uLogFile;

var g_log4me: TLogFile;

function  getLog4FileName(): AnsiString; //�õ���ǰ��־�ļ�ȫ��
begin
  Result := g_log4me.getLog4FileName();
end;

procedure setLogLevel(const level: AnsiString);
begin
  g_log4me.setLogLevel(level);
end;

function getLogLevel(): String;
begin
  Result := g_log4me.getLogLevel;
end;

//-----����4���Ƕ��ⷽ��-------------------------

procedure  log4error(msg: AnsiString); //дERROR�������־
begin
  g_log4me.log4error(msg);
end;

procedure  log4warn(msg: AnsiString); //дERROR�������־
begin
  g_log4me.log4warn(msg);
end;

procedure  log4info(msg: AnsiString); //дINFO�������־
begin
  g_log4me.log4info(msg);
end;

procedure  log4debug(msg: AnsiString); //дDEBUG�������־
begin
//  TThread.Queue(nil,
//  procedure
//  begin
  g_log4me.log4debug(msg);
//  end);
end;

// ----------- ���ʼ�� -------------//
initialization
  g_log4me := TLogFile.create('');
//  InitializeCriticalSection(log_ThreadLock);
//  log_init;
//  log4info('log4me:application starting....');

// ----------- ������ -------------//
finalization
  if Assigned(g_log4me) then begin
    g_log4me.Free;
  end;
//  log4info('log4me:application stoping....');
//  DeleteCriticalSection(log_ThreadLock);
//  if Assigned(log_fileStream) then begin
//    log_fileStream.Free;
//  end;

end.
