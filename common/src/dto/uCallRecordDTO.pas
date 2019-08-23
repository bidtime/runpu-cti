unit uCallRecordDTO;

interface

uses System.JSON.Types;

type

  TCallRecordBase = class
  private
  protected
    startTime: string;
    ringTime: string;
    establishedTime: string;
    finishedTime: string;
  public
    { Public declarations }
    callUuid: string;
    durationSeconds: integer;
    totalSeconds: integer;
    //
    finishedReason: integer;
    finishedReasonName: string;
    fromPhone: string;
    toPhone: string;
    //
    deviceType: Smallint;
    callType: Smallint;
    direction: Smallint;
    callResult: Smallint;
    //
    fileKey: string;
    fileName: string;
    fileSize: integer;
    //
    upFlag: integer;
    upResNums: integer;
    upDataNums: integer;

    function getStartTime(): string;
    class function transJson(const json: string;
      const fm: TJsonFormatting=TJsonFormatting.None): string;
    property beginTime: string read startTime;
  end;

  TCallRecordDTO = class(TCallRecordBase)
  private
    { Private declarations }
    function getUUIDFileRes: string;
    function getUUIDFileJson(): string;
  protected
    procedure resetStartTime;
  public
    { Public declarations }
    upFlagName: string;
    callTypeName: string;
    callResultName: string;
    //
    fileHandle: longint;
    upLog: string;
    callLog: string;
    ver: string;
    //
    constructor create();
    destructor Destroy(); override;
    function toStrs(): string;
    procedure resetVal();
    //procedure getTestInfo();
    function toJson: string; virtual;
    function toJsonV(const fm: TJsonFormatting=TJsonFormatting.None): string;
    procedure incUpResNums();
    procedure incUpDataNums();
    procedure setUpFlag(const n: integer);
    //
    function getUpSta(): string;
    function saveToFile(const fName: string): boolean;
    function saveToUUIDFile(): boolean; overload;
    procedure setCallType(const n: Smallint);
    procedure setCallResult(const n: Smallint);
    function fmtStartDay(): string;
    function validUUID(): boolean;
    procedure setCallUUID(const uuid: string);
    function crConnect(const n: Smallint): boolean;
    function toBaseJson(): string;
    //
    property resFileName: string read getUUIDFileRes;
    property jsonFileName: string read getUUIDFileJson;
 end;

implementation

uses Classes, SysUtils, uFileRecUtils, uJsonFUtils, uDateTimeUtils, uRecInf,
  brisdklib, uVerInfo;

constructor TCallRecordDTO.create;
begin
  inherited;
  resetVal;
end;

procedure TCallRecordDTO.resetStartTime();
var dt: TDateTime;
begin
  dt := now;
  StartTime := TDateTimeUtils.Dt2Str(dt);
  RingTime := TDateTimeUtils.Dt2Str(dt);
  EstablishedTime := TDateTimeUtils.Dt2Str(dt);
  FinishedTime := TDateTimeUtils.Dt2Str(dt);
  // caculate
  durationSeconds := 0;
  totalSeconds := 0;
end;

procedure TCallRecordDTO.resetVal();
begin
  callUuid := '';
  resetStartTime();
  //
  FromPhone := '0';
  ToPhone := '1';
  //
  finishedReason := 0;
  finishedReasonName := '';
  //
  //direction := CALLT_CALLOUT;     // 1:来电; 2:去电
  //callType := CALLT_CALLOUT;    // 呼叫类型  1:来电; 2:去电
  setCallType(CALLT_CALLOUT);
  //
  //callResult := CRESULT_NULL;
  setCallResult(CRESULT_NULL);   //呼叫结果 1:呼入未接; 2:呼入拒接; 3:呼出检测到回铃; 4:接通; 5: 非盒子拨号
  //
  fileKey := '';
  fileName := '';
  fileSize := 0;
  //
  deviceType := 4;    //此为官方盒子
  //
  self.setUpFlag(0);  //
  upResNums := 0;
  upDataNums := 0;
  //
  fileHandle := -1;
  //
  callLog := '';
  upLog := '';
  ver := getVerInfo;
end;

function TCallRecordDTO.saveToFile(const fName: string): boolean;
var b: boolean;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      b := TJsonFUtils.SerializeF<TCallRecordDTO>(self, fName,
        TJsonFormatting.Indented);
    end);
  Result := b;
end;

function TCallRecordDTO.saveToUUIDFile(): boolean;
var jsonFile: string;
begin
  jsonFile := getUUIDFileJson();
  Result := saveToFile(jsonFile);
end;

function TCallRecordDTO.getUUIDFileJson(): string;
begin
  Result := TFileRecUtils.getDirOfRec(TRecInf.CALL) + callUUID + TRecInf.JSON_EXT;
end;

function TCallRecordDTO.getUUIDFileRes: string;
begin
  Result := TFileRecUtils.getDirOfRec(TRecInf.CALL) + callUUID + TRecInf.RES_EXT;
end;

procedure TCallRecordDTO.setCallResult(const n: Smallint);

  function getCallRtName(): string;
  begin
    case n of
      0: begin
          Result := '初始化';
        end;
      1: begin
          Result := '呼入未接';
        end;
      2: begin
          Result := '呼入拒接';
        end;
      3: begin
          Result := '呼出检测到回铃';
        end;
      4: begin
          Result := '接通';
        end;
      5: begin
          Result := '非盒子通话';
        end;
      else begin
        Result := '未知';
      end;
    end;
  end;

begin
  self.callResult := n;
  self.callResultName := getCallRtName;
end;

procedure TCallRecordDTO.setCallType(const n: SmallInt);

  function getName(): string;
  begin
    case callType of
      0: begin
          Result := '初始化';
        end;
      1: begin
          Result := '呼入';
        end;
      2: begin
          Result := '呼出';
        end;
      else begin
        Result := '未知';
      end;
    end;
  end;

begin
  self.callType := n;
  // 1:来电; 2:去电
  if n=1 then begin
    direction := 1;
  end else if n=2 then begin
    direction := 2;
  end else begin
    direction := n;
  end;
  callTypeName := getName();
end;

procedure TCallRecordDTO.setCallUUID(const uuid: string);
begin
  callUUID := uuid;
end;

//const UP_FLAG_RES = 0;
//const UP_FLAG_DATA = 1;
//const UP_FLAG_FINAL = 2;

procedure TCallRecordDTO.setUpFlag(const n: integer);

  function getName(): string;
  begin
    case n of
      0: begin
          Result := '准备';
        end;
      1: begin
          Result := '待上传json';
        end;
      2: begin
          Result := '上传完成';
        end;
      else begin
        Result := '未知';
      end;
    end;
  end;

begin
  self.upFlag := n;
  self.upFlagName := getName();
end;

destructor TCallRecordDTO.destroy;
begin
  inherited;
end;

function TCallRecordDTO.fmtStartDay: string;
begin
  Result := TDateTimeUtils.Dt2StrDay(TDateTimeUtils.Str2Dt(startTime));
end;

function TCallRecordDTO.toStrs(): string;
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Add('callUuid' + '=' + callUuid);
    strs.Add('startTime' + '=' + startTime);
    strs.Add('ringTime' + '=' + ringTime);
    strs.Add('establishedTime' + '=' + establishedTime);
    strs.Add('finishedTime' + '=' + finishedTime);
    strs.Add('durationSeconds' + '=' + IntToStr(durationSeconds));
    strs.Add('totalSeconds' + '=' + IntToStr(totalSeconds));
    strs.Add('callType' + '=' + IntToStr(callType));
    //strs.Add('direction' + '=' + IntToStr(direction));
    strs.Add('callResult' + '=' + IntToStr(callResult));
    strs.Add('fromPhone' + '=' + fromPhone);
    strs.Add('toPhone' + '=' + toPhone);
    //
    strs.Add('finishedReason' + '=' + IntToStr(finishedReason));
    strs.Add('finishedReasonName' + '=' + finishedReasonName);
    //
    strs.Add('fileKey' + '=' + fileKey);
    strs.Add('fileName' + '=' + fileName);
    strs.Add('fileSize' + '=' + IntToStr(fileSize));
    strs.Add('deviceType' + '=' + IntToStr(deviceType));
    //strs.Add('upFlag' + '=' + IntToStr(upFlag));
    Result := strs.Text;
  finally
    strs.Free;
  end;
end;

{function TCallRecordDTO.cr(const n: Smallint): Smallint;
begin
  self.callResult := n;
  Result := n;
end;}

function TCallRecordDTO.crConnect(const n: Smallint): boolean;
begin
  self.callResult := n;
  Result := (n = CRESULT_CONNECTED);
end;

function TCallRecordDTO.toBaseJson: string;
begin
  Result := TCallRecordBase.transJson(toJsonV());
end;

function TCallRecordDTO.toJson(): string;
begin
  Result := TJsonFUtils.Serialize<TCallRecordDTO>(self);
end;

function TCallRecordDTO.toJsonV(const fm: TJsonFormatting): string;

  procedure validFmt();
  begin
    if fromPhone.IsEmpty then begin
      if (self.calltype = CALLT_CALLIN) then begin
        fromPhone := '00000000';
      end else if (calltype = CALLT_CALLOUT) then begin
        fromPhone := '00000001';
      end else begin
        fromPhone := '0020';
      end;
    end;
    if toPhone.IsEmpty then begin
      if (calltype = CALLT_CALLIN) then begin
        toPhone := '00000010';
      end else if (calltype = CALLT_CALLOUT) then begin
        toPhone := '00000011';
      end else begin
        toPhone := '0021';
      end;
    end;
  end;

begin
  validFmt();
  Result := TJsonFUtils.Serialize<TCallRecordDTO>(self, fm);
end;

function TCallRecordDTO.validUUID: boolean;
begin
  Result := not callUuid.IsEmpty;
end;

{procedure TCallRecordDTO.getTestInfo();
begin
  callUuid := '1';
  startTime := TDateTimeUtils.Now2Str();
  ringTime := TDateTimeUtils.Now2Str();
  establishedTime := TDateTimeUtils.Now2Str();
  finishedTime := TDateTimeUtils.Now2Str();
  durationSeconds := 6;
  totalSeconds := 10;
//  finishedReason := 7;
//  finishedReasonName := '2';
  callType := 1;    //呼叫类型  1:来电; 2:去电
  //
  callResult := 4;  //呼叫结果 1:呼入未接; 2:呼入拒接; 3:呼出检测到回铃; 4:接通
  //
  fromPhone := '测试又';
  toPhone := '123456789';
  //
  fileKey := '';
  fileName := '';
  fileSize := 0;
end;}

function TCallRecordDTO.getUpSta: string;
var S: string;
begin
  case self.upFlag of
    0: begin
      S := '资源上传失败, 第(' + IntToStr(upResNums) + ')次';
    end;
    1: begin
      S := '数据上传失败, 第(' + IntToStr(upDataNums) + ')次';
    end;
    2: begin
      S := '数据上传成功, 第(' + IntToStr(upDataNums) + ')次';
    end;
    else begin
      S := '上传状态未知, 资源第(' + IntToStr(upDataNums) + ')次' +
        '数据第(' + IntToStr(upDataNums) + ')次';
    end;
  end;
  Result := S;
end;

procedure TCallRecordDTO.incUpDataNums;
begin
  inc(upDataNums);
end;

procedure TCallRecordDTO.incUpResNums;
begin
  inc(upResNums);
end;

{ TCallRecordBase }

function TCallRecordBase.getStartTime: string;
begin
  Result := self.startTime;
end;

class function TCallRecordBase.transJson(const json: string;
  const fm: TJsonFormatting): string;
var u: TCallRecordBase;
begin
  Result := '';
  u := TJsonFUtils.Deserialize<TCallRecordBase>(json);
  try
    if Assigned(u) then begin
      Result := TJsonFUtils.Serialize<TCallRecordBase>(u, fm);
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

end.

