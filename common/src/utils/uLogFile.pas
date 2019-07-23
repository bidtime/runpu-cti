{
 ����ʵ�õ�DELPHI��־��Ԫ 1.0.1
 2011-7-10 p5soft.com


 ���ñ���Ԫ����ʹ��

 һ���ĸ�����
procedure  log4error(msg: AnsiString); //дERROR�������־
procedure  log4warn(msg: AnsiString); //дWARN�������־
procedure  log4info(msg: AnsiString); //дINFO�������־
procedure  log4debug(msg: AnsiString); //дDEBUG�������־

function  log4filename():AnsiString; //�õ���ǰ��־�ļ�ȫ��

 һ�������ļ�
 log4me.ini


#�����ļ�����������ͬһĿ¼.û������ļ�������Ŀ¼����д��־
[log4me]
#path,��־�Ĵ��Ŀ¼.������������Ŀ¼����Ŀ¼.
#����:������Ŀ¼
#path=.
#����:��Ŀ¼
#path=temp\logs
path=logs
#level,��־�ȼ�,ֻ���� error,warn,info,debug֮һ
#Ϊerrorʱ,ֻ��log4error��ӡ����־�����.
#Ϊwarnʱ,��log4error,log4warn��ӡ����־�����.
#Ϊinfoʱ,log4error,log4warn��log4info��ӡ����־�����.
#Ϊdebugʱ,log4error,log4warn,log4info,log4debug��ӡ����־�������.
level=info

 һ����ѡ����
 tail.exe

 ������������ >tail.exe -1000f ��־�ļ���
 ���ɶ�̬�鿴��־���
 ���ó������
 var
  cmd :AnsiString;
  log_file:AnsiString;
 begin
  log_file := log4filename();  //�õ���ǰ��־�ļ�ȫ��
  cmd := ExtractFilePath(ParamStr(0)) + 'tail.exe -1000f "'+ log_file +'"';
  WinExec(PAnsiChar(cmd),SW_SHOWNORMAL); //������� tail.exe�������鿴��־
}

unit uLogFile;

interface

uses classes, sysutils, windows, IniFiles;

type
  TLogFile = class
  private
    fLogfile: String; //��־�ļ�ȫ��
    ffileflag: string;
    log_ThreadLock: TRTLCriticalSection; // �ٽ���
    log_fileStream: TFileStream;
    //log_initime: TDateTime;
    log_doerror, log_dowarn, log_dodebug, log_doinfo: Boolean;
    //
    log_fullpath: AnsiString;                 //��־�ļ�ȫ·��
    log_arcpath: AnsiString;                 //��־archiveĿ¼
    log_path: AnsiString;                     //��־Ŀ¼
    log_level: AnsiString;                    //��־����
    function getLogFileExt: string;
  protected
    procedure setLogPath(const path: AnsiString);
    function getLogPath(): AnsiString;
    procedure createLogDays(const today: TDateTime; const nDiff: integer);
    function getLogFileByDay(const dt: TDateTime): string;
    procedure log_init(const flag: string);
    procedure log4me_addLog(fName: AnsiString; p: PAnsiChar);
    procedure log4write(msg: AnsiString);
    procedure makeFileList(Path: string; const FileExt: string; strs: TStrings;
      const maxRows: integer);
    procedure read_write_ini(const bWrite: boolean);
    procedure setLog4Level(const level: AnsiString);
    procedure setLogFilePath(const path: AnsiString);
    procedure zipArchFile(const fName: string);
    procedure zipBeforeDay(const today: TDateTime);
    function zipFile2(const fName, zipName: string): boolean;               //��ʼ��ʱ��zip before days
  public
    constructor Create(const flag: string);
    destructor Destroy; override;
    //
    procedure  log4error(msg: AnsiString); //дERROR�������־
    procedure  log4warn(msg: AnsiString); //дERROR�������־
    procedure  log4info(msg: AnsiString); //дINFO�������־
    procedure  log4debug(msg: AnsiString); //дDEBUG�������־
    procedure setLogLevel(const level: AnsiString);
    function getLogLevel(): String;
    function  getLog4FileName(): AnsiString; //�õ���ǰ��־�ļ�ȫ��
  end;

implementation

uses DateUtils, zip, uVerInfo;

function getRootDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TLogFile.setLogFilePath(const path: AnsiString);
begin
  log_path := path;
  log_fullpath := getRootDir() + log_path + '\';
  log_arcpath := log_fullpath + 'archive' + '\';
  ForceDirectories(log_fullpath);
  ForceDirectories(log_arcpath);
end;

procedure TLogFile.setLog4Level(const level: AnsiString);
begin
  log_doerror :=  (level = 'debug') or (level = 'info') or (level = 'warn') or (level = 'error');
  log_dowarn :=  (level = 'debug') or (level = 'info') or (level = 'warn');
  log_doinfo  :=  (level = 'debug') or (level = 'info');
  log_dodebug :=  (level = 'debug');
  if (not log_doerror) and (not log_dowarn) and (not log_doinfo)
    and (not log_dodebug) then begin
    raise Exception.Create('��־��������ǣ�debug��info��warn��error');
  end;
  log_level := level;
end;

function TLogFile.getLogFileByDay(const dt: TDateTime): string;
begin
  Result := log_fullpath + FormatDateTime('yyyy-mm-dd', dt) + getLogFileExt;
end;

function TLogFile.getLogFileExt(): string;
begin
  if ffileflag.IsEmpty then begin
    Result := '.log';
  end else begin
    Result := '_' + ffileflag + '.log';
  end;
end;

procedure TLogFile.read_write_ini(const bWrite: boolean);

  procedure readIni(iniFile: TIniFile);
  var path, level: string;
  begin
    path := iniFile.ReadString('log4me', 'path', 'log');
    level := LowerCase(iniFile.ReadString('log4me', 'level', 'info'));
    //
    setLogFilePath(path);
    setLog4Level(level);
  end;

  procedure writeIni(iniFile: TIniFile);
  begin
    iniFile.WriteString('log4me', 'path', log_path);
    iniFile.WriteString('log4me', 'level', log_level);
  end;

var fileName: string;
  iniFile: TIniFile;
begin
  fileName := getRootDir() + '\' + 'log4me.ini';
  iniFile := Tinifile.Create(filename);
  try
    if not bWrite then begin
      readIni(iniFile);
    end else begin
      writeIni(iniFile);
    end;
  finally
    iniFile.Free;
  end;
end;

function TLogFile.zipFile2(const fName: string; const zipName: string): boolean;
var
  zf:TZipFile;
begin
  Result := false;
  zf := TZipFile.Create;
  try
    try
      //����ZIPѹ���ļ�
      zf.Open(zipName, zmWrite);
      zf.Add(fName);
      zf.Close;
      Result := true;
    except
      on E: Exception do begin
        log4error('zipfile2: ' + e.Message);
      end;
    end;
  finally
    zf.Free;
  end;
end;

procedure TLogFile.zipArchFile(const fName: string);
var zipName: string;
begin
  if FileExists(fName) then begin
    zipName := log_arcpath +  ExtractFileName(ChangeFileExt(fName, '.zip'));
    if (zipFile2(fName, zipName)) then begin
      DeleteFile(PChar(fName));
    end;
  end;
end;

procedure TLogFile.makeFileList(Path: string; const FileExt: string; strs: TStrings;
  const maxRows:integer);
var
  sch: TSearchrec;
  sFull, sExt: string;
begin
  //if RightStr(trim(Path), 1) <> '\' then begin
  if not Path.EndsWith('\') then begin
    Path := Path + '\';
  end;
  if not SysUtils.DirectoryExists(Path) then begin
    exit;
  end;
  //
  //if FindFirst(Path + '*', faAnyfile, sch) = 0 then begin
  if SysUtils.FindFirst(Path + '\*.*', faAnyfile, sch) = 0 then begin
    repeat
      //Application.ProcessMessages;
      sleep(0);
      if ((sch.Name = '.') or (sch.Name = '..')) then begin
        Continue;
      end;
      if (maxRows>-1) and (strs.Count >= maxRows) then begin
        break;
      end;
      sFull := Path + sch.Name;
      sExt := ExtractFileExt(sFull);
      {if (includeSub) and DirectoryExists(sFull) then begin
        MakeFileList(sFull, FileExt, strs, maxRows, includeSub);
      //end else if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt))
      end else}
      if SameText(sExt, FileExt) or (FileExt='.*') then begin
        strs.Add( sFull );
      end;
      //
      sleep(0);
    until SysUtils.FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

function getFileDate(const s: string): TDateTime;
var hFile: THandle;
begin
  hFile := FileOpen(s, fmOpenRead);
  try
    if (hFile<0) or (FileGetDate(hFile)=-1) then begin
      Result := 0;
    end else begin
      Result := FileDateToDateTime(FileGetDate(hFile));
    end;
  finally
    FileClose(hFile);
  end;
end;

procedure TLogFile.zipBeforeDay(const today: TDateTime);

  function sameD(const s: string): boolean;
  var dtFile, dtNow: TDateTime;
    n: integer;
  begin
    dtFile := getFileDate(s);
    dtNow := now;
    if (SameDate(dtNow, dtFile)) then begin
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  procedure zipStrs(strs: TStrings);
  var I: integer;
    S, todayLog: string;
  begin
    todayLog := getLogFileByDay(today);
    for I := 0 to strs.Count - 1 do begin
      S := strs[I];
      if SameText(S, todayLog) then begin
        continue;
      end else if (sameD(S)) then begin
        continue;
      end else begin
        zipArchFile(S);
      end;
    end;
  end;

var I: integer;
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    if self.ffileflag.IsEmpty then begin
      makeFileList(log_fullpath, getLogFileExt(), strs, 31);
      zipStrs(strs);
    end;
  finally
    strs.Free;
  end;
end;

procedure TLogFile.createLogDays(const today: TDateTime; const nDiff: integer);
var I: integer;
  logFName: string;
  tf: TextFile;
begin
  for I := 0 to nDiff + 10 do begin
    logFName := getLogFileByDay(IncDay(today, -I));
    AssignFile(tf, logFName);
    ReWrite(tf);
    Append(Tf);
    WriteLn(Tf, logFName);
    CloseFile(tf);
    sleep(0);
  end;
end;

procedure TLogFile.log_init(const flag: string);
begin
  ffileflag := flag;
  fLogfile := '';
  log_doerror := False;

  log_dowarn := False;
  log_dodebug := False;
  log_doinfo := False;
  //
  read_write_ini(false);
  //createLogDays(Now(), 15);
  zipBeforeDay(Now());
  //log_initime := Now;
end;

procedure TLogFile.setLogLevel(const level: AnsiString);
begin
  setLog4Level(level);
  read_write_ini(true);
end;

function TLogFile.getLogLevel(): String;
begin
  Result := log_level;
end;

procedure TLogFile.setLogPath(const path: AnsiString);
begin
  setLogFilePath(path);
  read_write_ini(true);
end;

function TLogFile.getLogPath(): AnsiString;
begin
  Result := log_path;
end;

procedure TLogFile.log4me_addLog(fName: AnsiString; p: PAnsiChar);

  procedure writeFileLog();
  var
    fmode :Word;
    tmp: AnsiString;
  begin
    try
      //���Ҫд����־�ļ��ʹ򿪵Ĳ�ͬ���ڳ����һ�����кͿ����ʱ����֣�
      //��رմ򿪵���־�ļ���
      if not SameText(fName, fLogfile) then begin
        if Assigned(log_fileStream) then begin
          log_fileStream.Free;
          log_fileStream := nil;
          // zip
          zipArchFile(fLogfile);
        end;
        //
        fLogfile := fName;
      end;

      //���Ҫд����־�ļ�û�д򿪣��ڳ����һ�����кͿ����ʱ����֣�
      //�����־�ļ���
      if not Assigned(log_fileStream) then begin
         if FileExists(fLogfile) then begin
           fmode := fmOpenWrite or fmShareDenyNone
         end else begin
           fmode := fmCreate or fmShareDenyNone ;
         end;
        log_fileStream := TFileStream.Create(fLogfile, fmode);
        log_fileStream.Position := log_fileStream.Size;
      end;
      //����־�ļ���д����־
      log_fileStream.Write(p^, strlen(p));
    except
      on E:Exception do begin
        try
          tmp := getRootDir() + '\' + 'log4me_err.log';
          if FileExists(tmp) then begin
             fmode := fmOpenWrite or fmShareDenyNone;
          end else begin
             fmode := fmCreate or fmShareDenyNone ;
          end;
          with TFileStream.Create(tmp, fmode) do begin
            Position := Size;
            tmp := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' ' +  E.Message +  #13#10;
            Write(tmp[1], Length(tmp));
            Free;
          end;
        except
        end;
      end;
    end;
  end;
begin
  EnterCriticalSection(log_ThreadLock);    //�����ٽ��������߳�ʱ���Ա�����Դ
  try
    writeFileLog();
  finally
    LeaveCriticalSection(log_ThreadLock);  //������Σ��뿪�ٽ���
  end;
end;

procedure TLogFile.log4write(msg: AnsiString);
var
  strline: AnsiString;
  dt: TDateTime;
begin
  // ���ÿ���ؼ���һ�������ļ�
//  if (Now() - log_initime) > (1/(24*60*60)) then begin
//    log_init();
//  end;
  //��־��ͷ��ʱ��
  dt := Now;
  strline := FormatDateTime('hh:nn:ss.zzz', dt) + ' ' + msg + #13#10;
  //д���������־�ļ���
  log4me_addLog(getLogFileByDay(dt), PAnsiChar(strline));
end;

//-----����4���Ƕ��ⷽ��-------------------------

function TLogFile.getLog4FileName(): AnsiString;
begin
  Result := fLogfile;
end;

procedure TLogFile.log4error(msg: AnsiString);
begin
  if log_doerror then begin
    log4write('[ERROR]' + msg);
  end;
end;

procedure TLogFile.log4warn(msg: AnsiString);
begin
  if log_dowarn then begin
    log4write('[WARN ]' + msg);
  end;
end;

procedure TLogFile.log4info(msg: AnsiString);
begin
  if log_doinfo then begin
    log4write('[INFO ]' + msg);
  end;
end;

procedure TLogFile.log4debug(msg: AnsiString);
begin
  if log_dodebug then begin
    log4write('[DEBUG]' + msg);
  end;
end;

constructor TLogFile.Create(const flag: string);
begin
  inherited create;
  log_fileStream := nil;
  InitializeCriticalSection(log_ThreadLock);
  log_init(flag);
  //
  log4info('start...');
  log4info(getAppInfo);
end;

destructor TLogFile.Destroy;
begin
  log4info('stop.');
  log4info('');
  DeleteCriticalSection(log_ThreadLock);
  if Assigned(log_fileStream) then begin
    log_fileStream.Free;
  end;
  inherited;
end;

end.
