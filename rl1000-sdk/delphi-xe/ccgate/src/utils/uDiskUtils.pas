unit uDiskUtils;

interface

uses Windows;

type
  TDiskUnit = record
  public
    FSize: Int64;
    FUnit: string;
    procedure setSize(const Size: Int64);
    property Size: int64 read FSize write setSize;
    //
    function fmtByte: string;
    function fmtKB(): string;
    function fmtMB(): string;
    function fmtGB(): string;
    function fmtAutoU(): string;
  end;

  TDiskInf = record
  public
    FDrive, FDrvVolume: string;
    FAvailU, FTotalU, FFreeU: TDiskUnit;
    procedure fitDrv(const Drive: string);
    procedure fit();
    function trans(): TDiskInf;
    function fmtDiskLabel(): string;
  end;

  TDiskUtils = class
  private
    class function getDiskInfo(const drv: string;
      out UsedBytes, TotalBytes, FreeAvail: Int64): Boolean; overload; static;
    class function GetDiskSerial(drv: string): string; static;
    class function getDiskVolume(drv: String): String; static;
  public
    { Public declarations }
 end;

implementation

uses SysUtils, AnsiStrings;

{ TDiskUtils }

const dod = 1024 * 1024;

class function TDiskUtils.getDiskInfo(const drv: string;
  out UsedBytes, TotalBytes, FreeAvail: Int64): Boolean;
begin
  Result := GetDiskFreeSpaceEx(PChar(drv), FreeAvail, TotalBytes, nil);
  if Result then begin
    UsedBytes := TotalBytes - FreeAvail;
  end else begin
    UsedBytes := 0;
    TotalBytes := 0;
    FreeAvail := 0;
  end;
end;

{获取C盘的卷标 格式化硬盘卷标改变}
//GetHardDiskSerial('c:\')
class function TDiskUtils.GetDiskSerial(drv: string): string;
var VolumeSerialNumber: DWORD;
  MaximumComponentLength: DWORD;
  FileSystemFlags: DWORD;
begin
  if drv[Length(drv)]=':' then begin
    drv := drv + '\';
  end;
  GetVolumeInformation(PChar(drv), nil, 0,
    @VolumeSerialNumber, MaximumComponentLength, FileSystemFlags, nil, 0);
  Result := IntToHex(HiWord(VolumeSerialNumber), 4) +
    '-' + IntToHex(LoWord(VolumeSerialNumber), 4);
end;

function toStr(const a: string; const c: char=#0): string;
var i: integer;
  t: char;
begin
  Result := '';
  for I := 1 to Length(a) do begin
    t := a[i];
    if t=c then begin
      break;
    end else begin
      Result := Result + t;
    end;
  end;
end;

//取得硬盘的卷标
class function TDiskUtils.getDiskVolume(drv: String) : String;
Var
  FSFlags, MaxLength: DWORD;
  VolName: String;
begin
  SetLength(VolName, 512);
  if drv[Length(drv)]=':' then begin
    drv := drv + '\';
  end;
  GetVolumeInformation(PChar(drv), PChar(VolName), Length(VolName), nil, MaxLength, FSFlags, nil,0);
  Result := toStr(VolName);
end;

{ TDiskInf }

function fmtSize(const val: int64): string;
const
  K = Int64(1024);
  M = K * K;
  G = K * M;
  T = K * G;
var vRst: double;
begin
  {if val < K then begin
    Result := Format('%d bytes', [val])
  end else if val < M then begin
    Result := Format('%f KB', [val / K])
  end else if val < G then begin
    Result := Format('%f MB', [val / M])
  end else if val < T then begin
    Result := Format('%f GB', [val / G])
  end else begin
    Result := Format('%f TB', [val / T]);
  end;}
  //Result := Format('可用空间: %f GB', [val/1024/1024/1024])
  //vRst := Round();
  vRst := Round(val / 1024 / 1024 /1024 * 100) / 100;
  Result := Format('可用空间: %f GB', [vRst])
end;

{function fmtSize(const val: int64): string;
const
  K = Int64(1024);
  M = K * K;
  G = K * M;
  T = K * G;
begin
  if val < K then begin
    Result := Format('%d bytes', [val])
  end else if val < M then begin
    Result := Format('%f KB', [val / K])
  end else if val < G then begin
    Result := Format('%f MB', [val / M])
  end else if val < T then begin
    Result := Format('%f GB', [val / G])
  end else begin
    Result := Format('%f TB', [val / T]);
  end;
end;}

procedure TDiskInf.fitDrv(const Drive: string);
  procedure setDiskSize();
  var availSize, totalSize, freeSize: Int64;
  begin
    TDiskUtils.getDiskInfo(Drive, availSize, totalSize, freeSize);
    //
    FAvailU.Size := availSize;
    FTotalU.Size := totalSize;
    FFreeU.Size := freeSize;
    //
    FDrvVolume := TDiskUtils.getDiskVolume(Drive);
  end;
begin
  FDrive := drive;
  setDiskSize();
end;

function TDiskInf.fmtDiskLabel: string;
const FMT_LABEL = '%s (%s) 属性';
begin
  Result := format(FMT_LABEL, [FDrvVolume, FDrive]);
end;

function TDiskInf.trans: TDiskInf;
begin
  //AvailUnit := fmtSize(AvailBytes);
  //TotalUnit := fmtSize(TotalBytes);
  //FreeUnit := fmtSize(FreeBytes);
end;

procedure TDiskInf.fit();
var drv: string;
begin
  drv := ExtractFileDrive(ParamStr(0));
  fitDrv(drv);
end;

{ TDiskUnit }

function TDiskUnit.fmtAutoU: string;
begin
  //Result := fmtSize(self.FSize);
end;

function TDiskUnit.fmtKB: string;
begin
  //Result := Format('%f bytes', [FSize/1024]);
  Result := FormatFloat('0,0.00', FSize/1024*100);
  Result := Result + ' KB';
end;

function TDiskUnit.fmtMB: string;
begin
  //Result := Format('%f bytes', [FSize/1024]);
  Result := FormatFloat('0,0.00', FSize/1024/1024);
  Result := Result + ' MB';
end;

function TDiskUnit.fmtGB: string;
begin
  //Result := Format('%f bytes', [FSize/1024]);
  Result := FormatFloat('0,0.00', FSize/1024/1024/1024);
  Result := Result + ' GB';
end;

function TDiskUnit.fmtByte: string;
begin
  //Result := Format('%d %s', [FSize, FUnit]);
  Result := FormatFloat('0,0', FSize) + ' ' + FUnit;
end;

procedure TDiskUnit.setSize(const Size: Int64);
begin
  FSize := Size;// Round(Size/1024);
  FUnit := 'byte';
end;

end.

