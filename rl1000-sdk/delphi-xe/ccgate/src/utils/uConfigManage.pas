unit uConfigManage;

interface

uses
  Classes, SysUtils, IniFiles;

type
  TConfigManage = class(TObject)
  private
  protected
    { Private declarations }
    FFileName: String;
    procedure readFromFile(iniFile: TIniFile); virtual;
    procedure writeToFile(iniFile: TIniFile); virtual;
  public
    { Public declarations }
    constructor Create(); overload;
    constructor Create(const S: string); overload;
    procedure readFile();
    procedure writeFile();
    destructor Destroy(); Override;
    class function SYS_INIFILE: String;
    class procedure WriteSectionValues(iniFile: TIniFile; const section: string; strs: TStrings); overload;
    class procedure WriteSectionValues(const section: string; strs: TStrings); overload;
    class procedure ReadSectionValues(const section: string; strs: TStrings);
    class procedure ReadValues(const section: string; strs: TStrings); overload;
    class procedure ReadValues(iniFile: TIniFile; const section: string; strs: TStrings); overload;
    class procedure LoadFromFile(strs: TStrings);
  end;

implementation

uses Forms;

{ TConfigManage }

constructor TConfigManage.Create(const S: string);
begin
  FFileName := ExtractFilePath(Application.ExeName) + S;
end;

constructor TConfigManage.Create;
begin
  Create(SYS_INIFILE);
end;

destructor TConfigManage.Destroy;
begin
  inherited;
end;

class procedure TConfigManage.LoadFromFile(strs: TStrings);
var cfg: TConfigManage;
begin
  cfg := TConfigManage.Create();
  try
    strs.LoadFromFile(cfg.FFileName);
  finally
    cfg.Free;
  end;
end;

class function TConfigManage.SYS_INIFILE: String;
begin
  Result := 'sys.ini';
end;

procedure TConfigManage.readFile();
var iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(FFileName);
  try
    readFromFile(iniFile);
  finally
    iniFile.Free;
  end;
end;

procedure TConfigManage.readFromFile(iniFile: TIniFile);
begin
end;

procedure TConfigManage.writeToFile(iniFile: TIniFile);
begin
end;

procedure TConfigManage.writeFile;
var iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(FFileName);
  try
    writeToFile(iniFile);
  finally
    iniFile.Free;
  end;
end;

class procedure TConfigManage.WriteSectionValues(iniFile: TIniFile; const section: string;
  strs: TStrings);
  procedure splitEqual(const section: string; const S: string);
  var str: TStrings;
  begin
    str := TStringList.Create;
    try
      str.StrictDelimiter := true;
      str.Delimiter := '=';
      str.DelimitedText := S;
      if str.Count>1 then begin
        iniFile.WriteString(section, str[0], str[1]);
      end else begin
        iniFile.WriteString(section, str[0], '');
      end;
    finally
      str.Free;
    end;
  end;
var i: integer;
  S: string;
begin
  for I := 0 to strs.Count - 1 do begin
    S := strs[I];
    splitEqual(section, S);
  end;
end;

class procedure TConfigManage.WriteSectionValues(const section: string; strs: TStrings);
  procedure saveStrsToFile(cfg: TConfigManage; strs: TStrings);
  var iniFile: TIniFile;
  begin
    iniFile := TIniFile.Create(cfg.FFileName);
    try
      TConfigManage.WriteSectionValues(iniFile, section, strs);
    finally
      iniFile.Free;
    end;
  end;
var cfg: TConfigManage;
begin
  cfg := TConfigManage.Create();
  try
    saveStrsToFile(cfg, strs);
  finally
    cfg.Free;
  end;
end;

class procedure TConfigManage.ReadSectionValues(const section: string; strs: TStrings);
  procedure loadStrsToFile(cfg: TConfigManage; strs: TStrings);
  var iniFile: TIniFile;
  begin
    iniFile := TIniFile.Create(cfg.FFileName);
    try
      iniFile.ReadSectionValues(section, strs);
    finally
      iniFile.Free;
    end;
  end;
var cfg: TConfigManage;
begin
  cfg := TConfigManage.create;
  try
    loadStrsToFile(cfg, strs);
  finally
    cfg.Free;
  end;
end;

class procedure TConfigManage.ReadValues(iniFile: TIniFile; const section: string; strs: TStrings);
var
  KeyList: TStringList;
  I: Integer;
begin
  KeyList := TStringList.Create;
  try
    iniFile.ReadSection(Section, KeyList);
    strs.BeginUpdate;
    try
      strs.Clear;
      for I := 0 to KeyList.Count - 1 do begin
        strs.Add(iniFile.ReadString(Section, KeyList[I], ''))
      end;
    finally
      strs.EndUpdate;
    end;
  finally
    KeyList.Free;
  end;
end;

class procedure TConfigManage.ReadValues(const section: string; strs: TStrings);

  procedure loadStrsToFile(cfg: TConfigManage; strs: TStrings);
  var iniFile: TIniFile;
  begin
    iniFile := TIniFile.Create(cfg.FFileName);
    try
      ReadValues(iniFile, section, strs);
    finally
      iniFile.Free;
    end;
  end;

var cfg: TConfigManage;
begin
  cfg := TConfigManage.create;
  try
    loadStrsToFile(cfg, strs);
  finally
    cfg.Free;
  end;
end;

end.
