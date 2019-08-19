unit uFileDataPost;

interface

uses
  Classes, SysUtils, ExtCtrls, uCallRecordDTO, uThreadTimer;

type
  THttpPostData = class
  public
    class function upload(const url: string; const callRecDTO: TCallRecordDTO;
      const tmConn: integer; const tmUpdate: integer): boolean;
  end;

  THttpPostFile = class
  public
    class function upload(const url, fileName: string; var recDTO: TCallRecordDTO;
      const tmConn, tmRes: integer): boolean;
  end;

  TFileDataProcess = class
  private
    class function upload(const fileUrl, dataUrl, jsonFileName: string;
      const tmConn, tmRes, tmUpdate: integer): integer; static;
  public
    class procedure uploadThread(const fileUrl, dataUrl, jsonFileName: string;
      const tmConn, tmRes, tmUpdate: integer); static;
  end;

  TFileDirProcess = class
  private
    //FMRESSync: TSimpleRWSync;
    FStrsDir: TStrings;
    FTimerUpScan: TThreadTimer;
    //FTimerUp: TTimer;
    FSubDir: string;
    FFileSize: Longint;
    FDoing: boolean;
    FClosed: boolean;
    procedure Timer1Timer(Sender: TThreadTimer);
    //procedure Timer2Timer(Sender: TObject);
    procedure upload(const jsonFileName: string; const tryNums: integer=1);
    //function getCurFileJson: string;
    procedure processDir();
    procedure makeFileList(Path: string; const FileExt: string; strs: TStrings;
      const includeSub: boolean; const maxRows:integer=-1); overload;
  public
    constructor Create();
    destructor Destroy; override;
    //
    procedure addCurJsonFile(const jsonFile: string);
    procedure setSubDir(const subD: string);
    procedure closed();
  end;

var g_FileDirProcess: TFileDirProcess;

implementation

uses System.JSON.Serializers, uFileRecUtils, uUploadDTO, uHttpUtils, StrUtils,
  uJsonFUtils, uPhoneConfig, Forms, uShowMsgBase, uDateTimeUtils, DateUtils,
  uTimeUtils, uFileUtils, uRecInf, uLog4me, brisdklib, uLocalRemoteCallEv;

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

{ TFileDirProcess }

procedure TFileDirProcess.closed;
begin
  FClosed := true;
end;

constructor TFileDirProcess.Create();
begin
  FFileSize := -1;
  //FMRESSync := TSimpleRWSync.create;
  FStrsDir := TStringList.Create;
  //
  FTimerUpScan := TThreadTimer.Create();
  FTimerUpScan.OnThreadTimer := Timer1Timer;
  //FTimerUpScan.Interval := g_PhoneConfig.UpScanInterv * TTimeCfg.minute;
  FTimerUpScan.Interval := 30 * TTimeCfg.second;
  //
  FDoing := false;
  FClosed := false;
  //FTimerUpScan.StartThread; // 启动线程
  //FTimerUpScan.Enabled := true;
  //
  {FTimerUp := TTimer.Create(nil);
  FTimerUp.Interval := g_PhoneConfig.UpInterv * TTimeCfg.second;
  FTimerUp.Enabled := true;
  FTimerUp.OnTimer := Timer2Timer;}
end;

destructor TFileDirProcess.Destroy;
begin
  FTimerUpScan.StopThread; // 停止线程，即停止计时
  FTimerUpScan.free;
  //FTimerUp.Free;
  //FMRESSync.Free;
  FStrsDir.Free;
  inherited;
end;

procedure TFileDirProcess.setSubDir(const subD: string);
begin
  FSubDir := subD;
  FTimerUpScan.StartThread;
  //FTimerUp.Enabled := true;
end;

procedure TFileDirProcess.makeFileList(Path: string; const FileExt: string; strs: TStrings;
  const includeSub: boolean; const maxRows:integer);
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
      Application.ProcessMessages;
      if (FClosed) then begin
        break;
      end;
      sleep(0);
      if ((sch.Name = '.') or (sch.Name = '..')) then begin
        Continue;
      end;
      if (maxRows>-1) and (strs.Count >= maxRows) then begin
        break;
      end;
      sFull := Path + sch.Name;
      sExt := ExtractFileExt(sFull);
      if (includeSub) and DirectoryExists(sFull) then begin
        MakeFileList(sFull, FileExt, strs, includeSub, maxRows);
      //end else if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt))
      end else if SameText(sExt, FileExt) or (FileExt='.*') then begin
        if (not g_LocalCallEv.callUuid.equals(sch.Name)) then begin
          strs.Add( sFull );
        end;
      end;
      //
      sleep(0);
    until SysUtils.FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

procedure TFileDirProcess.processDir;

  procedure doStrs(const strs: TStrings);
  var i: integer;
    S: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      if FClosed then begin
        break;
      end;
      S := strs[I];
      upload(S);
      delaySec(g_PhoneConfig.UpInterv, FClosed);
    end;
  end;

begin
  //self.FMRESSync.BeginWrite();
  try
    if FStrsDir.Count<=0 then begin
      self.MakeFileList(FSubDir, TRecInf.JSON_EXT, FStrsDir, false);
      log4debug('processDir: make list,' + format('size(%d)', [FStrsDir.Count]));
    end else begin
      log4debug('processDir: list,' + format('size(%d)', [FStrsDir.Count]));
    end;
    doStrs(FStrsDir);
  finally
    //self.FMRESSync.EndWrite();
  end;
end;

CONST UP_S_NONE = -1;
CONST UP_S_RES = 0;
CONST UP_S_DATA = 1;
CONST UP_S_SUCCESS = 2;
CONST UP_S_FAIL = 3;

procedure TFileDirProcess.upload(const jsonFileName: string; const tryNums: integer);
var I, n: integer;
begin
  //self.FMRESSync.BeginWrite();
  try
    if (not jsonFileName.IsEmpty) and (FileExists(jsonFileName)) then begin
      for I := 0 to tryNums - 1 do begin
        n := TFileDataProcess.upload(g_PhoneConfig.UpResUrl, g_PhoneConfig.UpDataUrl
          , jsonFileName, g_PhoneConfig.UpConnTimeOut * TTimeCfg.minute
          , g_PhoneConfig.UpResTimeOut * TTimeCfg.minute
          , g_PhoneConfig.UpDataTimeOut  * TTimeCfg.minute);
        if ((n=UP_S_RES) or (n=UP_S_DATA)) then begin
          delaySec(10, FClosed);
          continue;
        end else begin
          break;
        end;
      end;
    end;
    Application.ProcessMessages;
  finally
    //self.FMRESSync.EndWrite();
  end;
end;

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

procedure TFileDirProcess.addCurJsonFile(const jsonFile: string);
begin
  self.upload(jsonFile, 1);
end;

procedure TFileDirProcess.Timer1Timer(Sender: TThreadTimer);
begin
  Sleep(0);
  if FDoing then begin
    exit;
  end;
  //
  FDoing := true;
  //Sender.StopThread;
  try
    processDir();
  finally
    //Sender.StartThread;
    FDoing := false;
  end;
  Sleep(0);
end;

{procedure TFileDirProcess.Timer2Timer(Sender: TObject);
begin
  Sleep(0);
  TTimer(Sender).enabled := false;
  try
    upload( getCurFileJson() );
  finally
    TTimer(Sender).enabled := true;
  end;
  Sleep(0);
end;}

{ TFileDataProcess }

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
//    end else if (TDateTimeUtils.DaysBetween(u.startTime) >=
//        g_phoneConfig.delRecInterv) then begin
      Result := MV_BAD;         // 3;                        //goto mvBad;
    end else begin
      Result := MV_UPLOADING;   //  1;                      //goto uploadingRes;
    end;
  end;

  function doPreUpData(const u: TCallRecordDTO): integer;
  begin
    if (u.upDataNums >= g_phoneConfig.UpDataMaxNum) then begin
      Result := MV_FAIL;  //2;                  //goto mvFail;
//    end else if (TDateTimeUtils.DaysBetween(u.startTime) >=
//        g_phoneConfig.delRecInterv) then begin
//      Result := MV_BAD;   // 3;                  //goto mvBad;
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
          if (THttpPostData.upload(dataUrl, u, tmConn, tmRes)) then begin
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
      TFileDataProcess.upload(fileUrl, dataUrl, jsonFileName, tmConn, tmRes, tmUpdate);
    end);
end;

{ THttpPostFile }

class function THttpPostFile.upload(const url, fileName: string;
  var recDTO: TCallRecordDTO; const tmConn, tmRes: integer): boolean;

  procedure cloneFileData(const fileData: TFileUpData);
  begin
    recDTO.fileKey := fileData.url;
    recDTO.fileName := fileData.name;
    recDTO.fileSize := fileData.size;
  end;

  function doEv(const S: string; var msg: string): boolean;
  var u: TReturnDTO<TFileUpData>;
  begin
    u := TReturnDTOUtils.DeSerialize<TFileUpData>(S);
    try
      if u.success then begin
        cloneFileData(u.data);
      end else begin
        msg := u.msg;
      end;
      Result := u.success;
    finally
      u.free;
    end;
  end;

var S, msg: string;
begin
  Result := false;
  try
    S := THttpUtils.upload(url, fileName, tmConn, tmRes);
    Result := doEv(S, msg);
    if Result then begin
      if recDTO.fileKey.IsEmpty then begin
        ShowSysLog(format('上传文件成功: %s, fileKey为空, %s', [url, fileName]));
      end else begin
        ShowSysLog(format('上传文件成功: %s, fileKey=%s, %s', [url, recDTO.fileKey, fileName]));
      end;
    end else begin
      ShowSysLog(format('上传文件失败: %s, %s, %s ', [url, msg, fileName]));
    end;
  except
    on E: Exception do begin
      ShowSysLog(format('上传文件出错: %s, %s, %s ', [url, e.Message, fileName]));
    end;
  end;
end;

{ THttpPostData }

class function THttpPostData.upload(const url: string; const callRecDTO: TCallRecordDTO;
  const tmConn: integer; const tmUpdate: integer): boolean;
var S, msg, ctx, json: string;
begin
  Result := false;
  try
    ctx := callRecDTO.toJsonV();
    json := TCallRecordBase.transJson(ctx);
    S := THttpUtils.postJson(url, json, tmConn, tmUpdate);
    Result := TReturnDTOUtils.success(S, msg);
    if Result then begin
      ShowSysLog(format('上传数据成功: %s, %s ', [url, ctx]));
    end else begin
      ShowSysLog(format('上传数据失败: %s, %s, %s ', [url, msg, ctx]));
    end;
  except
    on E: Exception do begin
      ShowSysLog(format('上传数据出错: %s, %s, %s ', [url, e.Message, ctx]));
    end;
  end;
end;

initialization
  g_FileDirProcess := TFileDirProcess.Create();

finalization
  g_FileDirProcess.Free;

end.


