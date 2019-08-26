unit uLogFileU;

interface

uses classes, sysutils, windows, uLogFile;

type
  TLogFileU = class
  private
  public
    constructor Create(const flag: string='');
    destructor Destroy; override;
  public
    class constructor Create();
    class destructor Destroy;
    //
    class procedure debug(msg: AnsiString); static;
    class procedure info(msg: AnsiString); static;
    class procedure error(msg: AnsiString); static;
    class procedure warn(msg: AnsiString); static;
  end;

implementation

var g_logFile: TLogFile;

constructor TLogFileU.Create(const flag: string);
begin
  inherited create;
end;

destructor TLogFileU.Destroy;
begin
  inherited;
end;

class procedure TLogFileU.debug(msg: AnsiString);
begin
  g_logFile.log4debug(msg);
end;

class procedure TLogFileU.info(msg: AnsiString);
begin
  g_logFile.log4info(msg);
end;

class procedure TLogFileU.error(msg: AnsiString);
begin
  g_logFile.log4error(msg);
end;

class procedure TLogFileU.warn(msg: AnsiString);
begin
//  TThread.Queue(nil,
//  procedure
//  begin
  g_logFile.log4warn(msg);
//  end);
end;

class constructor TLogFileU.Create();
begin
  g_logFile := TLogFile.create('D');
end;

class destructor TLogFileU.Destroy;
begin
  if Assigned(g_logFile) then begin
    g_logFile.Free;
  end;
end;

end.
