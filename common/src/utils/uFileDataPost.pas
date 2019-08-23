unit uFileDataPost;

interface

uses
  Classes, SysUtils, ExtCtrls, uCallRecordDTO, uUploadDTO, uFileStrsProcess;

type
  TFileDataProcess = class
  private
    class function uploadRaw(const fileUrl, dataUrl, jsonFileName: string;
      const tmConn, tmRes, tmUpdate: integer): integer; static;
  public
    class procedure uploadThread(const fileUrl, dataUrl, jsonFileName: string;
      const tmConn, tmRes, tmUpdate: integer); static;
  end;

  TFileJsonProcess = class
  private
    FTimerPost: TTimer;
    FStrsDir: TStrings;
    procedure Timer1Timer(Sender: TObject);
    function getCurJsonFile: string;
  public
    constructor Create();
    destructor Destroy; override;
    procedure starttimer();
    procedure endtimer;
    procedure setStrsDir(strs: TStrings);
    property StrsDir: TStrings read FStrsDir write SetStrsDir;
  end;

  TFileDirProcess = class
  private
    FSubDir: string;
    FFileStrs: TFileStrsProcess;
    FJsonProcess: TFileJsonProcess;
    //
    FTimerUpScan: TTimer;
    procedure Timer1Timer(Sender: TObject);
  public
    constructor Create();
    destructor Destroy; override;
    procedure setSubDir(const subD: string);
    procedure starttimer();
    procedure endtimer;
  end;

var g_FileDirProcess: TFileDirProcess;

implementation

uses uFileRecUtils, StrUtils, windows,
  uJsonFUtils, uPhoneConfig, Forms, uShowMsgBase, uDateTimeUtils, DateUtils,
  uTimeUtils, uFileUtils, uRecInf, uLog4me, brisdklib, uLocalRemoteCallEv,
  uHttpException, uHttpResultDTO;

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

{ TFileDirProcess }

constructor TFileDirProcess.Create();
begin
  inherited;
  FFileStrs := TFileStrsProcess.Create;
  FJsonProcess := TFileJsonProcess.Create;
  //
  FTimerUpScan := TTimer.create(nil);
  FTimerUpScan.Enabled := false;
  //FTimerUpScan.Interval := g_PhoneConfig.UpScanInterv * TTimeCfg.minute;
  FTimerUpScan.Interval := 5 * TTimeCfg.second;
  FTimerUpScan.OnTimer := Timer1Timer;
end;

destructor TFileDirProcess.Destroy;
begin
  FJsonProcess.Free;
  //
  FTimerUpScan.Enabled := false;
  FTimerUpScan.free;
  FFileStrs.Free;
  inherited;
end;

procedure TFileDirProcess.setSubDir(const subD: string);
begin
  //FFileStrs.SubDir := subD;
  FSubDir := subD;
  FTimerUpScan.Enabled := true;
end;

procedure TFileDirProcess.starttimer;
begin
  FTimerUpScan.Enabled := true;
end;

procedure TFileDirProcess.endtimer;
begin
  FTimerUpScan.Enabled := true;
end;

procedure TFileDirProcess.Timer1Timer(Sender: TObject);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      TTimer(Sender).Enabled := false;
      try
        if FJsonProcess.StrsDir.Count<=0 then begin
          FJsonProcess.endtimer;
          //
          FFileStrs.readStrs(FSubDir, FJsonProcess.StrsDir);
          //FJsonProcess.SetStrsDir( FFileStrs.StrsDir );
          //
          FJsonProcess.starttimer;
        end;
      finally
        TTimer(Sender).Enabled := true;
      end;
      Sleep(0);
    end);
end;

{ TFileJosonProcess }

constructor TFileJsonProcess.Create();
begin
  inherited;
  FStrsDir := TStringList.Create;
  FTimerPost := TTimer.create(nil);
  FTimerPost.Enabled := false;
  //FTimerPost.Interval := g_PhoneConfig.UpInterv * TTimeCfg.minute;
  FTimerPost.Interval := 15 * TTimeCfg.second;
  FTimerPost.OnTimer := Timer1Timer;
  //FTimerUpScan.Interval := 30 * TTimeCfg.second;
end;

destructor TFileJsonProcess.Destroy;
begin
  FTimerPost.Enabled := false;
  FTimerPost.free;
  //
  FStrsDir.Free;
  inherited;
end;

procedure TFileJsonProcess.endtimer;
begin
  FTimerPost.Enabled := false;
end;

procedure TFileJsonProcess.setStrsDir(strs: TStrings);
begin
  self.FStrsDir.Assign( strs );
  starttimer;
end;

procedure TFileJsonProcess.starttimer;
begin
  FTimerPost.Enabled := true;
end;

function TFileJsonProcess.getCurJsonFile(): string;
begin
  if (not p_closed^) and (FStrsDir.count > 0) then begin
    Result := FStrsDir[0];
    ShowSysLog('get file:' + Result);
    FStrsDir.Delete(0);
  end else begin
    ShowSysLog('get file: empty');
    Result := '';
  end;
end;

procedure TFileJsonProcess.Timer1Timer(Sender: TObject);
var b: boolean;
begin
  TThread.Synchronize(nil,
    procedure
    var jsonFileName: string;
    begin
      TTimer(Sender).Enabled := false;
      try
        b := false;
        jsonFileName := getCurJsonFile();
        if (not jsonFileName.IsEmpty) then begin
          try
            TFileDataProcess.uploadThread(g_PhoneConfig.UpResUrl, g_PhoneConfig.UpDataUrl
              , jsonFileName, g_PhoneConfig.UpConnTimeOut * TTimeCfg.minute
              , g_PhoneConfig.UpResTimeOut * TTimeCfg.minute
              , g_PhoneConfig.UpDataTimeOut  * TTimeCfg.minute);
            b := true;
          except
            on e: THttpBreakException do begin
              b := false;
            end;
            on e: THttpNoLoginException do begin
              b := false;
            end;
          end;
          //
          if (not b) then begin
            FStrsDir.Clear;
            ShowSysLog('error, strs count set 0');
          end else begin
            ShowSysLog('strs count is 0');
          end;
        end else begin
          ShowSysLog('strs count is 0');
        end;
      finally
        TTimer(Sender).Enabled := b;
      end;
      Sleep(0);
    end);
end;

{class procedure TFileJsonProcess.doStrs(const strs: TStrings);
var process: TFileJsonProcess;
begin
  process := TFileJsonProcess.Create;
  try
    process.setStrsDir(strs);
  finally
    process.Free;
  end;
  Sleep(0);
end;}

{function TFileDirProcess.getCurFileJson(): string;
begin
  self.FMRESSync.BeginWrite();
  try
    if FStrsDir.count > 0 then begin
      Result := FStrsDir[0];
      FStrsDir.Delete(0);
    end else begin
      Result := '';
    end;
    if (FFileSize<>FStrsDir.Count) then begin
      FFileSize := FStrsDir.Count;
      log4debug('curFileJson: ' + format('size(%d)', [FStrsDir.Count]));
    end;
  finally
    self.FMRESSync.EndWrite();
  end;
end;}

{ TFileDataProcess }

CONST UP_S_NONE = -1;
CONST UP_S_RES = 0;
CONST UP_S_DATA = 1;
CONST UP_S_SUCCESS = 2;
CONST UP_S_FAIL = 3;

const MV_BAD = 3;
const MV_FAIL = 2;
const MV_UPLOADING = 1;

const UP_FLAG_RES = 0;
const UP_FLAG_DATA = 1;
const UP_FLAG_FINAL = 2;

class function TFileDataProcess.uploadRaw(const fileUrl, dataUrl: string;
  const jsonFileName: string; const tmConn, tmRes, tmUpdate: integer): integer;

  function doPreUpRes(const u: TCallRecordDTO): integer;
  begin
    if (u.upResNums >= g_phoneConfig.UpResMaxNum) then begin
      Result := MV_FAIL;        //  2;                        //goto mvFail;
    end else if (TDateTimeUtils.DaysBetween(u.beginTime) >=
        g_phoneConfig.delRecInterv) then begin
      Result := MV_BAD;         // 3;                        //goto mvBad;
    end else begin
      Result := MV_UPLOADING;   //  1;                      //goto uploadingRes;
    end;
  end;

  function doPreUpData(const u: TCallRecordDTO): integer;
  begin
    if (u.upDataNums >= g_phoneConfig.UpDataMaxNum) then begin
      Result := MV_FAIL;  //2;                  //goto mvFail;
    end else if (TDateTimeUtils.DaysBetween(u.beginTime) >=
        g_phoneConfig.delRecInterv) then begin
      Result := MV_BAD;   // 3;                  //goto mvBad;
    end else begin
      Result := MV_UPLOADING; //1;                  //goto uploadingRes;
    end;
  end;

  procedure mvFileToDir(const resFileName: string; const jsonFileName: string;
      const sub_: string; const strDay: string);

    procedure mvFileToDir_(const resFileName: string; const jsonFileName: string;
        const sub: string);

      procedure mv_name_(const fName: string; const dstName: string);
      var b: boolean;
      begin
        b := TFileUtils.rename_force(fName, dstName);
        ShowSysLog(format('移动文件: %s, %s->%s', [ BoolToStr(b, true),
          resFileName, dstName ]));
      end;

      procedure mv_sub_name(const fName: string; const sub: string);
      var dstName, dstPath: string;
      begin
        dstPath := TFileRecUtils.getDirOfRec(sub);
        ForceDirectories(dstPath);
        dstName := ChangeFilePath(fName, dstPath);
        mv_name_(fName, dstName);
      end;

    begin
      mv_sub_name(resFileName, sub);
      mv_sub_name(jsonFileName, sub);
    end;
  var dtDay: TDateTime;
  begin
    dtDay := TDateTimeUtils.Str2Dt(strDay);
    mvFileToDir_(resFileName, jsonFileName, sub_
      + '\' + formatDateTime('yyyy\yyyy-mm\yyyy-mm-dd', dtDay));
  end;

var u: TCallRecordDTO;
  resFileName: string;
  nUpResState, nUpDataState: integer;
label mvUpload, mvToBad, preUploadRes, uploadRes, aftUploadRes, uploadData, mvFail;
begin
  Result := UP_S_NONE;
  u := TJsonFUtils.DeSerializeNF<TCallRecordDTO>(jsonFileName);
  try
    if not Assigned(u) then begin
      if FileExists(jsonFileName) then begin
        ShowSysLog('json数据: 文件格式无效, ' + jsonFileName);
        u.upLog := 'json数据: 文件格式无效';
        u.saveToFile(jsonFileName);
      end else begin
        ShowSysLog('json数据: 文件不存在, ' + jsonFileName);
      end;
      goto mvToBad;
    end else if (u.callType <> CALLT_CALLIN) and (u.callType <> CALLT_CALLOUT) then begin
      ShowSysLog(format('json数据: 呼叫类型异常, callType=%d(%s), %s',
        [u.callType, u.callTypeName, u.resFileName]));
      u.upLog := format('json数据: 呼叫类型异常, callType=%d(%s)',
        [u.callType, u.callTypeName]);
      u.saveToFile(jsonFileName);
      goto mvToBad;
    end else if (u.callUuid.IsEmpty) then begin                   //如果uuid为空不用传了，移到文件到bad
      ShowSysLog('json数据: uuid为空, ' + jsonFileName);
      u.upLog := 'json数据: uuid为空';
      u.saveToFile(jsonFileName);
mvToBad:
      resFileName := u.resFileName;
      if resFileName.IsEmpty then begin
        resFileName := ChangeFileExt(jsonFileName, TRecInf.RES_EXT);
      end;
      mvFileToDir(resFileName, jsonFileName, TRecInf.BAD, u.getStartTime);
    //end else if (u.callResult = CRESULT_NULL) or (u.callResult = CRESULT_NODONE)
//    end else if (u.callResult <> CRESULT_CONNECTED) then begin          //如果callResult为0不用传了，移动文件到bad
//      ShowSysLog(format('json数据: 电话未接通, callResult=%d(%s), %s',
//        [u.callResult, u.callResultName, u.resFileName]));
//      goto uploadData;
    end else begin
      resFileName := u.resFileName;
      ShowSysLog( format('开始上传: %s(%s, %s)', [
        ChangeFileExt(jsonFileName, ''),
        TRecInf.RES_EXT,
        TRecInf.JSON_EXT
      ]) );
preUploadRes:
      if (u.upFlag = UP_FLAG_RES) then begin                          //都全传(file、data)
        Result := UP_S_RES;
        if FileExists(resFileName) then begin             //存在录音文件的情况下
          // 判断录音时长是否满足有效通话时效: s
          if (u.durationSeconds <= g_phoneConfig.ValidCallPeriod) then begin
            ShowSysLog(format('待上传资源: 放弃录音, 时长(%d)s, callResult(%d), %s', [
              u.durationSeconds, u.callResult, resFileName ]));
            u.upLog := format('放弃录音, 时长(%d)s', [u.durationSeconds]);
            u.saveToFile(jsonFileName);
            goto aftUploadRes;
          end else begin
            u.incUpResNums();
            u.saveToFile(jsonFileName);
            //
            nUpResState := doPreUpRes(u);
            ShowSysLog(format('准备上传资源: %s, callResult=%d, %d, %s', [
                IfThen(u.callResult <> CRESULT_CONNECTED, '未接通', '已接通'),
                u.callResult,
                nUpResState,
                resFileName
              ]));
            if (nUpResState=MV_UPLOADING) then begin
uploadRes:
              if THttpPostFile.upload(fileUrl, resFileName, u, tmConn, tmRes) then begin
                goto aftUploadRes;
              end;
            end else if (nUpResState=MV_FAIL) or (nUpResState=MV_BAD) then begin
//              u.memo := format('json数据: 超过%d次的重试次数', [g_phoneConfig.UpResMaxNum]);
//              u.saveToFile(jsonFileName);
              goto mvFail;
            end;
          end;
        end else begin
aftUploadRes:
          u.setUpFlag(UP_FLAG_DATA);
          if (not u.saveToFile(jsonFileName)) then begin
            log4error('recDTO save error: ' + jsonFileName);
          end;
          goto uploadData;
        end;
      end else if (u.upFlag = UP_FLAG_DATA) then begin     //只传data
        if FileExists(resFileName) then begin
          ShowSysLog('资源已经上传: ' + resFileName);
        end else begin
          ShowSysLog('无资源不用上传: ' + resFileName);
        end;
uploadData:
        Result := UP_S_DATA;
        u.incUpDataNums();
        u.saveToFile(jsonFileName);
        nUpDataState := doPreUpData(u);
        ShowSysLog(format('准备上传数据: %d, %s',
          [nUpDataState, jsonFileName]));
        if (nUpDataState=MV_UPLOADING) then begin
          if (THttpPostData.post(dataUrl, u, tmConn, tmRes)) then begin
            u.setUpFlag(UP_FLAG_FINAL);
            u.saveToFile(jsonFileName);
            goto mvUpload;
          end;
        end else if (nUpDataState=MV_FAIL) or (nUpDataState=MV_BAD) then begin
          goto mvFail;
        end;
      end else if (u.upFlag = UP_FLAG_FINAL) then begin     //其它不用传了，移到文件到upload
mvUpload:
        ShowSysLog('上传数据: 完成, 移到up目录, ' + jsonFileName);
        mvFileToDir(resFileName, jsonFileName, TRecInf.UPLOAD, u.getStartTime);
        Result := UP_S_SUCCESS;
      end else begin                                  //其它不用传了，移到文件到bad
mvFail:
        ShowSysLog('上传数据: 失败, 移到fail目录, ' + jsonFileName);
        mvFileToDir(resFileName, jsonFileName, TRecInf.FAIL, u.getStartTime);
        Result := UP_S_FAIL;
      end;
    end;
  finally
    ShowSysLog(format('结束上传: %s, %s(%s, %s)', [u.getUpSta(),
      ChangeFileExt(jsonFileName, ''),
      TRecInf.RES_EXT,
      TRecInf.JSON_EXT]));
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

class procedure TFileDataProcess.uploadThread(const fileUrl, dataUrl,
  jsonFileName: string; const tmConn, tmRes, tmUpdate: integer);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    TFileDataProcess.uploadRaw(fileUrl, dataUrl, jsonFileName, tmConn, tmRes, tmUpdate);
  end);
end;

initialization
  g_FileDirProcess := TFileDirProcess.Create();

finalization
  g_FileDirProcess.Free;

end.


