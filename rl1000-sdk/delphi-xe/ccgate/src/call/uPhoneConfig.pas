unit uPhoneConfig;

interface

uses
  Classes;

type
  TTimeCfg = class
  private
  public
    class function minute(): integer; static;
    class function second(): integer; static;
    class function ms(): integer; static;
  end;

  TPhoneConfig = class
  private
    function getCurDir: string;
  protected
    function readWriteIni(const bWrite: boolean): boolean;
    function readIni(): boolean;
  public
    // record
    RecFileFormat: integer;
    FileEcho: boolean;
    FileAgc: boolean;
    AutoCallRec: boolean;
    ValidCallPeriod: integer;
    // am
    MicAM: integer;
    SpkAM: integer;
    //
    Host: string;
    Port: integer;
    // upload res
    UpResUrl: string;
    UpResTimeOut: integer;
    UpResMaxNum: integer;
    // upload data
    UpDataUrl: string;
    UpDataTimeOut: integer;
    UpDataMaxNum: integer;
    UpConnTimeOut: integer;
    // upload
    UpInterv: smallint;
    UpScanInterv: smallint;
    //
    delRecInterv: smallint;
    delRecScanInterv: smallint;
    //
    delLogInterv: smallint;
    delLogScanInterv: smallint;
    //
    hangAftInterv: smallint;
    //
    LogMaxLines: integer;
    //
    ctrlWatchDog: boolean;
    //
    CallInAutoConfirm: boolean;
    DialUpAutoConfirm: boolean;
    //
    upgradeURL: string;
    upgradeInterv: smallint;
    //
    OutPrefix: string;
    CallingNo: string;
    ExtNo: String;
    { Public declarations }
    constructor Create(const read: boolean);
    destructor Destroy; override;
    function resetConfig(): boolean;
    function writeIni(): boolean;
    function httpInfo(): string;
  end;

var g_phoneConfig: TPhoneConfig;

implementation

uses SysUtils, IniFiles;

{ TMyHttpServer }

constructor TPhoneConfig.Create(const read: boolean);
begin
  inherited create;
  resetConfig();
  if read then begin
    readIni();
  end;
end;

destructor TPhoneConfig.Destroy;
begin
  inherited;
end;

function TPhoneConfig.httpInfo: string;
begin
  Result := 'http://' + host + ':' + IntToStr(port);
end;

function TPhoneConfig.getCurDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function TPhoneConfig.readIni(): boolean;
begin
  Result := readWriteIni(false);
end;

function TPhoneConfig.resetConfig(): boolean;
begin
  // rec param
  RecFileFormat := 0;
  FileEcho := true;
  FileAgc := true;
  // auto rec
  AutoCallRec := true;
  ValidCallPeriod := 10;
  // am
  SpkAM := -1;
  MicAM := -1;
  // host
  Host := '127.0.0.1';
  Port := 12686;
  // upload res
  UpResUrl := '';
  UpResTimeOut := 10;             // 10m
  UpResMaxNum := 5000;
  // upload data
  UpDataUrl := '';
  UpDataTimeOut := 2;             // 2m
  UpDataMaxNum := 5000;
  // upload
  UpConnTimeOut := 1;             // 1m
  UpInterv := 20;                 // 20s
  UpScanInterv := 30;          // 30m
  //
  delRecInterv := 45;         // 30 day
  delRecScanInterv:=240;      // 60 * 4 h
  //
  delLogInterv := 60;     // 45 day
  delLogScanInterv:=300;  // 60 * 5h
  //
  LogMaxLines := 200;
  ctrlWatchDog := true;
  //
  CallInAutoConfirm := true;
  DialUpAutoConfirm := true;
  //
  upgradeURL := '';
  upgradeInterv := 5;      // 1 minute
  hangAftInterv := 5;
  //
  OutPrefix := '0';
  CallingNo := '';
  ExtNo := '1234';
  //
  Result := true;
end;

function TPhoneConfig.readWriteIni(const bWrite: boolean): boolean;
  procedure readWriteIni_phone();
  var fileName: string;
    iniFile: TIniFile;
  begin
    fileName := getCurDir() + '\' + 'phonecfg.ini';
    iniFile := Tinifile.Create(filename);
    try
      if not bWrite then begin
        // rec param
        RecFileFormat := iniFile.ReadInteger('rec', 'recFileFormat', recFileFormat);
        FileEcho := iniFile.Readbool('rec', 'fileEcho', fileEcho);
        FileAgc := iniFile.Readbool('rec', 'fileAgc', fileAgc);
        // auto rec
        AutoCallRec := iniFile.Readbool('rec', 'autoCallRec', autoCallRec);
        ValidCallPeriod := iniFile.ReadInteger('rec', 'validCallPeriod', validCallPeriod);
        // rec confirm
        CallInAutoConfirm := iniFile.ReadBool('rec', 'callInAutoConfirm', CallInAutoConfirm);
        DialUpAutoConfirm := iniFile.ReadBool('rec', 'dialUpAutoConfirm', DialUpAutoConfirm);
        // am
        //FSpkAM := iniFile.ReadInteger('am', 'SpkAM', FSpkAM);
        //FMicAM := iniFile.ReadInteger('am', 'MicAM', FMicAM);
        // host
        Host := iniFile.ReadString('server', 'host', Host);
        Port := iniFile.ReadInteger('server', 'port', Port);
        LogMaxLines := iniFile.ReadInteger('server', 'logMaxLines', LogMaxLines);
        // upload res
        UpResUrl := iniFile.ReadString('up_res', 'url', UpResUrl);
        UpResTimeOut := iniFile.ReadInteger('up_res', 'timeOut', UpResTimeOut);
        UpResMaxNum := iniFile.ReadInteger('up_res', 'maxNum', UpResMaxNum);
        // upload data
        UpDataUrl := iniFile.ReadString('up_data', 'url', UpDataUrl);
        UpDataTimeOut := iniFile.ReadInteger('up_data', 'timeOut', UpDataTimeOut);
        UpDataMaxNum := iniFile.ReadInteger('up_data', 'maxNum', UpDataMaxNum);
        // upload
        UpConnTimeOut := iniFile.ReadInteger('upload', 'connTimeOut', UpConnTimeOut);
        upScanInterv := iniFile.ReadInteger('upload', 'upScanInterv', upScanInterv);
        upInterv := iniFile.ReadInteger('upload', 'upInterv', upInterv);
        hangAftInterv := iniFile.ReadInteger('upload', 'hangAftInterv', hangAftInterv);
        //
        delRecScanInterv := iniFile.ReadInteger('removeDir', 'delRecScanInterv', delRecScanInterv);
        delRecInterv := iniFile.ReadInteger('removeDir', 'delRecInterv', delRecInterv);
        //
        delLogScanInterv := iniFile.ReadInteger('removeDir', 'delLogScanInterv', delLogScanInterv);
        delLogInterv := iniFile.ReadInteger('removeDir', 'delLogInterv', delLogInterv);
        //
        ctrlWatchDog := iniFile.ReadBool('removeDir', 'ctrlWatchDog', ctrlWatchDog);
        //
        Result := true;
      end else begin
        // rec param
        iniFile.WriteInteger('rec', 'recFileFormat', RecFileFormat);
        iniFile.Writebool('rec', 'fileEcho', FileEcho);
        iniFile.Writebool('rec', 'fileAgc', FileAgc);
        // auto rec
        iniFile.Writebool('rec', 'autoCallRec', AutoCallRec);
        iniFile.WriteInteger('rec', 'validCallPeriod', ValidCallPeriod);
        // rec confirm
        iniFile.Writebool('rec', 'callInAutoConfirm', CallInAutoConfirm);
        iniFile.Writebool('rec', 'dialUpAutoConfirm', DialUpAutoConfirm);
        // am
        //iniFile.WriteInteger('am', 'SpkAM', FSpkAM);
        //iniFile.WriteInteger('am', 'MicAM', FMicAM);
        // host
        iniFile.WriteString('server', 'host', Host);
        iniFile.WriteInteger('server', 'port', Port);
        iniFile.WriteInteger('server', 'logMaxLines', LogMaxLines);
        // upload res
        iniFile.WriteString('up_res', 'url', UpResUrl);
        iniFile.WriteInteger('up_res', 'timeOut', UpResTimeOut);
        iniFile.WriteInteger('up_res', 'maxNum', UpResMaxNum);
        // upload data
        iniFile.WriteString('up_data', 'url', UpDataUrl);
        iniFile.WriteInteger('up_data', 'timeOut', UpDataTimeOut);
        iniFile.WriteInteger('up_data', 'maxNum', UpDataMaxNum);
        iniFile.WriteInteger('upload', 'hangAftInterv', hangAftInterv);
        // upload
        iniFile.WriteInteger('upload', 'connTimeOut', UpConnTimeOut);
        iniFile.WriteInteger('upload', 'upScanInterv', upScanInterv);
        iniFile.WriteInteger('upload', 'upInterv', upInterv);
        //
        iniFile.WriteInteger('removeDir', 'delRecScanInterv', delRecScanInterv);
        iniFile.WriteInteger('removeDir', 'delRecInterv', delRecInterv);
        //
        iniFile.WriteInteger('removeDir', 'delLogScanInterv', delLogScanInterv);
        iniFile.WriteInteger('removeDir', 'delLogInterv', delLogInterv);
        //
        iniFile.WriteBool('removeDir', 'ctrlWatchDog', ctrlWatchDog);
        //
        Result := true;
      end;
    finally
      iniFile.Free;
    end;
  end;
  procedure readWriteIni_dail();
  var fileName: string;
    iniFile: TIniFile;
  begin
    fileName := getCurDir() + '\' + 'sys.ini';
    iniFile := Tinifile.Create(filename);
    try
      if not bWrite then begin
        OutPrefix := iniFile.ReadString('dailup', 'outPrefix', OutPrefix);
        CallingNo := iniFile.ReadString('dailup', 'callingNo', CallingNo);
        ExtNo := iniFile.ReadString('dailup', 'extNo', ExtNo);
        Result := true;
      end else begin
        iniFile.WriteString('dailup', 'outPrefix', OutPrefix);
        iniFile.WriteString('dailup', 'callingNo', CallingNo);
        iniFile.WriteString('dailup', 'extNo', ExtNo);
        Result := true;
      end;
    finally
      iniFile.Free;
    end;
  end;
  procedure readWriteIni_upgrade();
  var fileName: string;
    iniFile: TIniFile;
  begin
    fileName := getCurDir() + '\' + 'upgrade.ini';
    iniFile := Tinifile.Create(filename);
    try
      if not bWrite then begin
        upgradeURL := iniFile.ReadString('upgrade', 'upgradeURL', upgradeURL);
        upgradeInterv := iniFile.ReadInteger('upgrade', 'upgradeInterv', upgradeInterv);
        Result := true;
      end else begin
        iniFile.writeString('upgrade', 'upgradeURL', upgradeURL);
        iniFile.WriteInteger('upgrade', 'upgradeInterv', upgradeInterv);
        Result := true;
      end;
    finally
      iniFile.Free;
    end;
  end;
  procedure readWriteIni_cpc();
  var fileName: string;
    iniFile: TIniFile;
  begin
    fileName := getCurDir() + '\' + 'cpcini\cpcconfig.ini';
    iniFile := Tinifile.Create(filename);
    try
      if not bWrite then begin
        OutPrefix := iniFile.ReadString('cpcparam', 'EXTCODE', upgradeURL);
        Result := true;
      end else begin
        iniFile.WriteString('cpcparam', 'EXTCODE', OutPrefix);
        Result := true;
      end;
    finally
      iniFile.Free;
    end;
  end;
begin
  readWriteIni_phone();
  readWriteIni_dail();
  readWriteIni_upgrade();
  readWriteIni_cpc();
  Result := true;
end;

function TPhoneConfig.writeIni(): boolean;
begin
  Result := readWriteIni(true);
end;

{ TTimeCfg }

class function TTimeCfg.minute: integer;
begin
  Result := 60 * second;
end;

class function TTimeCfg.second: integer;
begin
  Result := 1000;
end;

class function TTimeCfg.ms: integer;
begin
  Result := 1000;
end;

initialization
  g_phoneConfig := TPhoneConfig.Create(true);

finalization
  g_phoneConfig.Free;

end.


