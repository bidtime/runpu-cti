unit uFileDataPost;

interface

uses
  Classes, SysUtils, ExtCtrls, uCallRecordDTO, uUploadDTO, uFileStrsProcess,
  uQueueBase;

type
  TFileDataProcess = class
  private
  public
    class function upload(const fileUrl, dataUrl, jsonFileName: string;
      const tmConn, tmRes, tmUpdate: integer): integer; static;
  end;
  TFileJsonProcess = class
  private
    FTimerPost: TTimer;
    FStrsDir: TStackBase<String>;
    procedure Timer1Timer(Sender: TObject);
    function doUpload(): boolean;
  public
    constructor Create();
    destructor Destroy; override;
    procedure starttimer();
    procedure endtimer;
    procedure setStrsDir(strs: TStackBase<String>);
    property StrsDir: TStackBase<String> read FStrsDir write SetStrsDir;
  end;

  TFileDirProcess = class
  private
    FSubDir: string;
    FJsonProcess: TFileJsonProcess;
    FStrsDir: TStackBase<String>;
    //
    FTimerUpScan: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure doReadStrs;
  public
    constructor Create();
    destructor Destroy; override;
    procedure setSubDir(const subD: string);
    procedure add(const jsonfile: string);
    procedure starttimer();
    procedure endtimer;
  end;

var g_FileDirProcess: TFileDirProcess;

implementation

uses uFileRecUtils, StrUtils, windows, uJsonFUtils, uPhoneConfig, Forms,
  uShowMsgBase, uDateTimeUtils, DateUtils, uTimeUtils, uFileUtils, uRecInf,
  brisdklib, uLocalRemoteCallEv, uHttpException, uHttpResultDTO, System.Threading;

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

{ TFileDirProcess }

constructor TFileDirProcess.Create();
begin
  inherited;
  FStrsDir := TStackBase<String>.create;
  FJsonProcess := TFileJsonProcess.Create;
  FJsonProcess.StrsDir := FStrsDir;
  //
  FTimerUpScan := TTimer.create(nil);
  FTimerUpScan.Enabled := false;
  FTimerUpScan.Interval := g_PhoneConfig.UpScanInterv * TTimeCfg.minute;
  //FTimerUpScan.Interval := 10 * TTimeCfg.second;
  FTimerUpScan.OnTimer := Timer1Timer;
end;

destructor TFileDirProcess.Destroy;
begin
  FJsonProcess.Free;
  //
  FTimerUpScan.Enabled := false;
  FTimerUpScan.free;
  //
  FStrsDir.Free;
  inherited;
end;

procedure TFileDirProcess.setSubDir(const subD: string);
begin
  FSubDir := subD;
  FTimerUpScan.Enabled := true;
end;

procedure TFileDirProcess.add(const jsonfile: string);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    FStrsDir.put(jsonfile);
    if FJsonProcess.FTimerPost.tag = 0 then begin
      FJsonProcess.starttimer;
    end;
  end);
end;

procedure TFileDirProcess.starttimer;
begin
  FTimerUpScan.Enabled := true;
end;

procedure TFileDirProcess.endtimer;
begin
  FTimerUpScan.Enabled := true;
end;

procedure TFileDirProcess.doReadStrs();
begin
  if self.FStrsDir.Count<=0 then begin
    FJsonProcess.endtimer;
    TFileQueueProcess.readStrs(FSubDir, FStrsDir);
    if FStrsDir.Count>0 then begin
      FJsonProcess.starttimer;
    end;
  end;
end;

procedure TFileDirProcess.Timer1Timer(Sender: TObject);
begin
  if (p_closed^) then begin
    ShowSysLog('stoped, exit');
    exit;
  end;
  TTimer(Sender).Enabled := false;
  FTimerUpScan.Tag := 1;
  try
    Sleep(0);
    Application.ProcessMessages;
    //TTask.run(procedure begin
      TThread.Synchronize(nil,
      procedure
      begin
        doReadStrs();
      end);
    //end);
  finally
    Sleep(0);
    Application.ProcessMessages;
    TTimer(Sender).Enabled := true;
    FTimerUpScan.Tag := 0;
  end;
end;

{ TFileJosonProcess }

constructor TFileJsonProcess.Create();
begin
  inherited;
  FTimerPost := TTimer.create(nil);
  FTimerPost.Enabled := false;
  FTimerPost.Interval := g_PhoneConfig.UpInterv * TTimeCfg.second;
  //FTimerPost.Interval := 15 * TTimeCfg.second;
  FTimerPost.OnTimer := Timer1Timer;
end;

destructor TFileJsonProcess.Destroy;
begin
  FTimerPost.Enabled := false;
  FTimerPost.free;
  inherited;
end;

procedure TFileJsonProcess.endtimer;
begin
  FTimerPost.Enabled := false;
end;

procedure TFileJsonProcess.setStrsDir(strs: TStackBase<String>);
begin
  //self.FStrsDir.Assign( strs );
  self.FStrsDir := strs;
  starttimer;
end;

procedure TFileJsonProcess.starttimer;
begin
  FTimerPost.Enabled := true;
end;

CONST UPLOAD_SYS_ERROR = -1;
CONST UPLOAD_FAIL = 0;
CONST UPLOAD_OK = 1;

function TFileJsonProcess.doUpload(): boolean;
  function getCurJsonFile(var S: string): boolean;
  begin
    if (FStrsDir.count > 0) then begin
      Result := true;
      //S := FStrsDir[0];
      //FStrsDir.Delete(0);
      S := FStrsDir.get();
      ShowSysLog( format('get file: %s, strs(%d)', [S, FStrsDir.count]));
    end else begin
      Result := false;
      S := '';
      ShowSysLog( format('get file: null, strs(%d)', [FStrsDir.count]));
    end;
  end;
var
  jsonFileName: string;
begin
  Result := getCurJsonFile(jsonFileName);
  if (Result) then begin
    if (jsonFileName.IsEmpty) then begin
      exit;
    end;
    try
      TFileDataProcess.upload(g_PhoneConfig.UpResUrl, g_PhoneConfig.UpDataUrl
        , jsonFileName, g_PhoneConfig.UpConnTimeOut * TTimeCfg.minute
        , g_PhoneConfig.UpResTimeOut * TTimeCfg.minute
        , g_PhoneConfig.UpDataTimeOut  * TTimeCfg.minute);
    except
      on e: THttpBreakException do begin
        FStrsDir.Clear;
        ShowSysLog('HttpBreakException, strs count set 0');
        Result := false;
      end;
      on e: THttpNoLoginException do begin
        FStrsDir.Clear;
        ShowSysLog('HttpNoLoginException, strs count set 0');
        Result := false;
      end;
    end;
  end;
end;

procedure TFileJsonProcess.Timer1Timer(Sender: TObject);
var
  bOK: boolean;
begin
  if (p_closed^) then begin
    ShowSysLog('stoped, exit');
    exit;
  end;
  bOK := true;
  TTimer(Sender).Enabled := false;
  TTimer(Sender).tag := 1;
  try
    Sleep(0);
    Application.ProcessMessages;
    //TTask.run(procedure begin
      TThread.Synchronize(nil,
      procedure
      begin
        bOK := doUpload();
        exit;
      end);
    //end);
  finally
    Sleep(0);
    Application.ProcessMessages;
    TTimer(Sender).Enabled := bOK;
    TTimer(Sender).tag := 0;
  end;
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

class function TFileDataProcess.upload(const fileUrl, dataUrl: string;
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
      end else begin
        ShowSysLog('json数据: 文件不存在, ' + jsonFileName);
      end;
      resFileName := ChangeFileExt(jsonFileName, TRecInf.RES_EXT);
      mvFileToDir(resFileName, jsonFileName, TRecInf.BAD, TDateTimeUtils.Now2Str());
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
            ShowSysLog('recDTO save error: ' + jsonFileName);
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
          if (THttpPostData.postS(dataUrl, u, tmConn, tmRes)) then begin
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
    if Assigned(u) then begin
      ShowSysLog(format('结束上传: %s, %s(%s, %s)', [u.getUpSta(),
        ChangeFileExt(jsonFileName, ''),
        TRecInf.RES_EXT,
        TRecInf.JSON_EXT]));
      u.Free;
    end;
  end;
end;

initialization
  g_FileDirProcess := TFileDirProcess.Create();

finalization
  g_FileDirProcess.Free;

end.


