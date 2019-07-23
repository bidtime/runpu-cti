unit uFileDirRemove;

interface

uses
  Classes, SysUtils, ExtCtrls, uCallRecordDTO, Generics.Collections;

type
  TFileDirRemove = class
  private
    FMRESSync: TSimpleRWSync;
    FExtName: string;
    FTimerDir: TTimer;
    FSrcSubDir: TStrings;
    FIncludeSub: boolean;
    FOnFile: TGetStrProc;
    procedure Timer1Timer(Sender: TObject);
    procedure processDir();
  public
    constructor Create(const interv: Cardinal);
    destructor Destroy; override;
    procedure addSubDir(const subDir: string);
    procedure setSubDir(const subDir: TStrings);
    procedure start();
    procedure stop();

    property IncludeSub: boolean read FIncludeSub write FIncludeSub;
    property OnFile: TGetStrProc read FOnFile write FOnFile;
  end;

  TFileDirRemoveManage = class
  private
    FFileRemoveRec: TFileDirRemove;
    FFileRemoveLog: TFileDirRemove;

    procedure doRecFile(const S: string);
    procedure doLogFile(const S: string);
  public
    constructor Create();
    destructor Destroy; override;
  end;

var g_FileDirRemoveManage: TFileDirRemoveManage;

implementation

uses Forms, uShowMsgBase, uPhoneConfig, uFileRecUtils, uFileUtils, DateUtils, uRecInf;

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

{ TFileDirRemove }

constructor TFileDirRemove.Create(const interv: Cardinal);
begin
  inherited create;
  FMRESSync := TSimpleRWSync.create;
  FSrcSubDir := TStringList.Create;
  FExtName := '.*';
  FIncludeSub := false;
  //
  FTimerDir := TTimer.Create(nil);
  FTimerDir.Enabled := false;
  FTimerDir.Interval := interv;//g_PhoneConfig.upScanInterv * TTimeCfg.minute;
  FTimerDir.OnTimer := Timer1Timer;
end;

destructor TFileDirRemove.Destroy;
begin
  FTimerDir.free;
  FMRESSync.Free;
  FSrcSubDir.Free;
  inherited;
end;

procedure TFileDirRemove.setSubDir(const subDir: TStrings);
begin
  self.FSrcSubDir.AddStrings(subDir);
end;

procedure TFileDirRemove.addSubDir(const subDir: string);
begin
  self.FSrcSubDir.add(subDir);
end;

procedure TFileDirRemove.start;
begin
  self.FTimerDir.enabled := true;
end;

procedure TFileDirRemove.stop;
begin
  self.FTimerDir.enabled := false;
end;

procedure TFileDirRemove.processDir;
begin
  self.FMRESSync.BeginWrite();
  try
    TFileUtils.getFileList(FSrcSubDir, FExtName, FIncludeSub, FOnFile);
  finally
    self.FMRESSync.EndWrite();
  end;
end;

procedure TFileDirRemove.Timer1Timer(Sender: TObject);
begin
  Sleep(0);
  TTimer(Sender).enabled := false;
  try
    processDir();
  finally
    TTimer(Sender).enabled := true;
  end;
  Sleep(0);
end;

{ TFileDirRemoveManage }

constructor TFileDirRemoveManage.Create;
begin
  inherited;
  FFileRemoveRec := TFileDirRemove.Create(g_PhoneConfig.delRecScanInterv * TTimeCfg.minute);
  FFileRemoveLog := TFileDirRemove.Create(g_PhoneConfig.delLogScanInterv * TTimeCfg.minute);
  //
  FFileRemoveRec.OnFile := doRecFile;
  FFileRemoveLog.OnFile := doLogFile;
  //
  FFileRemoveRec.addSubDir(TFileRecUtils.getDirOfRec(TRecInf.BAD));
  FFileRemoveRec.addSubDir(TFileRecUtils.getDirOfRec(TRecInf.FAIL));
  FFileRemoveRec.addSubDir(TFileRecUtils.getDirOfRec(TRecInf.UPLOAD));
  FFileRemoveRec.addSubDir(TFileRecUtils.getDirOfRec(TRecInf.CALL));
  //
  FFileRemoveRec.addSubDir(TFileRecUtils.getDirOfSub(TRecInf.LOG));
  //
  FFileRemoveRec.start;
  FFileRemoveRec.start;
end;

destructor TFileDirRemoveManage.Destroy;
begin
  FFileRemoveRec.stop;
  FFileRemoveLog.stop;
  //
  FFileRemoveRec.free;
  FFileRemoveLog.free;
  inherited;
end;

procedure TFileDirRemoveManage.doLogFile(const S: string);
var dtCreate: TDateTime;
begin
  FileAge(S, dtCreate);
  if DaysBetween(Now, dtCreate)>g_PhoneConfig.delLogInterv then begin
    //TFileUtils.delete(S);
  end;
end;

procedure TFileDirRemoveManage.doRecFile(const S: string);
var dtCreate: TDateTime;
begin
  FileAge(S, dtCreate);
  if DaysBetween(Now, dtCreate)>g_PhoneConfig.delRecInterv then begin
    //TFileUtils.delete(S);
  end;
end;

initialization
  g_FileDirRemoveManage := TFileDirRemoveManage.Create();

finalization
  g_FileDirRemoveManage.Free;

end.


