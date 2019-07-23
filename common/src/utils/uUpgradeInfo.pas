unit uUpgradeInfo;

interface

type

  TUpgradeInfo = class
  private
  public
    ver_no: double;     // 0.2
    dl_force: boolean;
    dl_url: string;    // http://172.16.200.225:81/file_up/fileupload.zip
    download: boolean;
    old_ver_no: double;
    //
    function comp(const v: double): boolean;
    function info(): string;
    constructor create;
    destructor Destroy; override;
  end;

  {TMemIniString = class(TMemIniFile)
  private
  public
    constructor Create(); overload;
    constructor Create(const Encoding: TEncoding); overload;
    destructor Destroy; override;
    //
    procedure setString(const S: string);
  end;}

  TUpgradeHelper = class
  private
    class function dl(const url: string; const verNo: double): TUpgradeInfo; overload;
  public
    class function dl(const url: string): TUpgradeInfo; overload;
    class function dl_slient(const url: string): TUpgradeInfo; static;
    class function isUpgrade(const url: string): boolean;
    class function getVerNo(const url: string): double;
    class function setVerNo(const url: string; const verNo: double): string; overload;
    class function setVerNo(const url: string; const verNo: string): string; overload;
  end;

implementation

uses SysUtils, uJsonSUtils, uSimpleHttp, System.Net.URLClient;

{ TUpgradeHelper }

const S_VerNo = 'verNo';

class function TUpgradeHelper.getVerNo(const url: string): double;
begin
  Result := strToFloatDef(TURI.create(url).ParameterByName[S_VerNo], 0);
end;

class function TUpgradeHelper.setVerNo(const url: string;
  const verNo: double): string;
begin
  Result := setVerNo(url, FloatToStr(verNo));
end;

class function TUpgradeHelper.setVerNo(const url: string;
  const verNo: string): string;
begin
  Result := url + '?' + S_VerNo + '=' + verNo;
end;

class function TUpgradeHelper.dl(const url: string): TUpgradeInfo;
begin
  Result := dl(url, getVerNo(url));
end;

class function TUpgradeHelper.dl_slient(const url: string): TUpgradeInfo;
begin
  try
    Result := dl(url, getVerNo(url));
  except
    on e: Exception do begin
      Result := nil;
    end;
  end;
end;

class function TUpgradeHelper.isUpgrade(const url: string): boolean;
begin
  Result := dl(url, getVerNo(url)).download;
end;

class function TUpgradeHelper.dl(const url: string; const verNo: double): TUpgradeInfo;

  function parse(const S: string): TUpgradeInfo;
  var u: TUpgradeInfo;
  begin
    u := TJsonSUtils.Deserialize<TUpgradeInfo>(S);
    try
      u.comp(verNo);
      Result := u;
    finally
      //u.Free;
    end;
  end;

var json: string;
begin
  json := THttpHelper.get(url, 5 * 1000, 30 * 1000);
  Result := parse(json);
end;

{ TMemIniString }

{constructor TMemIniString.Create(const Encoding: TEncoding);
begin
  inherited create('', encoding);
end;

constructor TMemIniString.Create;
begin
  inherited create('');
end;

destructor TMemIniString.Destroy;
begin
  inherited;
end;

procedure TMemIniString.setString(const S: string);
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Add(S);
    inherited SetStrings(strs);
  finally
    strs.Free;
  end;
end;}

{ TUpgradeInfo }

function TUpgradeInfo.comp(const v: double): boolean;
begin
  old_ver_no := v;
  if self.ver_no=v then begin
    Result := false;
  end else if self.ver_no>v then begin
    Result := true;
  end else begin
    if self.dl_force then begin
      Result := true;
    end else begin
      Result := false;
    end;
  end;
  download := Result;
end;

constructor TUpgradeInfo.create;
begin
  ver_no := 0;     // 0.2
  dl_force := false;
  dl_url := '';    // http://172.16.200.225:81/file_up/fileupload.zip
  download := false;
  old_ver_no := 0;
end;

destructor TUpgradeInfo.Destroy;
begin
  inherited;
end;

function TUpgradeInfo.info(): string;
begin
  Result := ' 运通电话盒子网关 ' + FloatToStr(old_ver_no) + ' 升级到 ' + FloatToStr(ver_no);
end;

end.
