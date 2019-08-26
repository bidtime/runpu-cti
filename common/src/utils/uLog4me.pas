unit uLog4me;

interface

uses classes;

procedure  log4error(msg: AnsiString); //写ERROR级别的日志
procedure  log4warn(msg: AnsiString); //写ERROR级别的日志
procedure  log4info(msg: AnsiString); //写INFO级别的日志
procedure  log4debug(msg: AnsiString); //写DEBUG级别的日志

function  getLog4FileName(): AnsiString; //得到当前日志文件全名

procedure setLogLevel(const level: AnsiString);
function getLogLevel(): String;

implementation

uses uLogFile;

var g_log4me: TLogFile;

function  getLog4FileName(): AnsiString; //得到当前日志文件全名
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

//-----下面4个是对外方法-------------------------

procedure  log4error(msg: AnsiString); //写ERROR级别的日志
begin
  g_log4me.log4error(msg);
end;

procedure  log4warn(msg: AnsiString); //写ERROR级别的日志
begin
  g_log4me.log4warn(msg);
end;

procedure  log4info(msg: AnsiString); //写INFO级别的日志
begin
  g_log4me.log4info(msg);
end;

procedure  log4debug(msg: AnsiString); //写DEBUG级别的日志
begin
//  TThread.Queue(nil,
//  procedure
//  begin
  g_log4me.log4debug(msg);
//  end);
end;

// ----------- 类初始化 -------------//
initialization
  g_log4me := TLogFile.create('');
//  InitializeCriticalSection(log_ThreadLock);
//  log_init;
//  log4info('log4me:application starting....');

// ----------- 类销毁 -------------//
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
