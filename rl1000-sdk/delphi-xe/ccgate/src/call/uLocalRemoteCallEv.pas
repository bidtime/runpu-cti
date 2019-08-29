unit uLocalRemoteCallEv;

interface

uses
  brisdklib, uCallRecordDTO;

type
  TLocalRemoteCallEv = class(TCallRecordDTO)
  private
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
    //
    procedure startRec();
    procedure startRing;
    procedure startDial;
    procedure endRec();
    //procedure setDurationSeconds(const secs: longint);
//    procedure setDurationSeconds(); overload;
    function toJson: string; override;
    function toJsonV: string;
    //
    procedure confirmCallIn(const uuid: string);
    procedure confirmDial(const uuid: string);
    //function upDataRes(): boolean;
    function getFmtTime: string;
    //class procedure upload(const json: string);
    class function fromJson(const json: string): TLocalRemoteCallEv;
  end;

var g_LocalCallEv: TLocalRemoteCallEv;
  p_LocalCallEv: ^TLocalRemoteCallEv;

implementation

uses Classes, SysUtils, uFileRecUtils, uFileDataPost, uJsonFUtils, uDateTimeUtils,
  uPhoneConfig, System.JSON.Types, uLog4me, uLogFileU;

{ TLocalRemoteCallEv }

procedure TLocalRemoteCallEv.confirmCallIn(const uuid: string);
begin
  //g_FileDirProcess.addCurJsonStr(self.callUuid, true);
end;

procedure TLocalRemoteCallEv.confirmDial(const uuid: string);
begin
  //g_FileDirProcess.addCurJsonStr(self.callUuid, true);
end;

constructor TLocalRemoteCallEv.Create();
begin
  inherited create;
end;

destructor TLocalRemoteCallEv.Destroy;
begin
  inherited;
end;

class function TLocalRemoteCallEv.fromJson(const json: string): TLocalRemoteCallEv;
begin
  Result := TJsonFUtils.DeSerialize<TLocalRemoteCallEv>(json);
end;

procedure TLocalRemoteCallEv.startDial;
begin
  resetStartTime();
end;

procedure TLocalRemoteCallEv.startRing;
var dt: TDateTime;
begin
  dt := now;
  RingTime := TDateTimeUtils.Dt2Str(dt);
  EstablishedTime := TDateTimeUtils.Dt2Str(dt);
  FinishedTime := TDateTimeUtils.Dt2Str(dt);
  // caculate
  durationSeconds := 0;
  totalSeconds := TDateTimeUtils.SecsBetween(FinishedTime, StartTime);
end;

procedure TLocalRemoteCallEv.startRec;
var dt: TDateTime;
begin
  dt := now;
  EstablishedTime := TDateTimeUtils.Dt2Str(dt);
  FinishedTime := TDateTimeUtils.Dt2Str(dt);
  // caculate
  durationSeconds := 0;
  totalSeconds := TDateTimeUtils.SecsBetween(FinishedTime, StartTime);
end;

procedure TLocalRemoteCallEv.endRec;
var dt: TDateTime;
begin
  dt := now;
  FinishedTime := TDateTimeUtils.Dt2Str(dt);
  // re caculate
  durationSeconds := TDateTimeUtils.SecsBetween(FinishedTime, EstablishedTime);
  totalSeconds := TDateTimeUtils.SecsBetween(FinishedTime, StartTime);
end;

function TLocalRemoteCallEv.getFmtTime(): string;

  function gt(const S: string): string;
  var pos: integer;
  begin
    pos := s.indexOf(' ');
    if (pos>=0) then begin
      Result := S.substring(pos+1, s.Length - pos);
    end else begin
      Result := S;
    end
  end;

begin
  Result := format('start(%s), ring(%s), estable(%s), finished(%s), ' +
        'duration(%ds), total(%ds)',
    [gt(startTime), gt(RingTime), gt(EstablishedTime), gt(FinishedTime),
      durationSeconds, totalSeconds]
  );
end;

function TLocalRemoteCallEv.toJson: string;
begin
  Result := TJsonFUtils.Serialize<TLocalRemoteCallEv>(self, TJsonFormatting.Indented);
end;

function TLocalRemoteCallEv.toJsonV: string;
begin
  Result := inherited toJsonV(TJsonFormatting.Indented);
end;

//function TLocalRemoteCallEv.upDataRes(): boolean;

//  function rename_force(const OldName, NewName: string): boolean;
//  begin
//    Result := false;
//    if not FileExists(OldName) then begin
//      exit;
//    end;
//    if FileExists(NewName) then begin
//      DeleteFile(NewName);
//    end;
//    Result := RenameFile(OldName, NewName);
//  end;
//
//  function renameFileRes: boolean;
//  begin
//    Result := rename_force(getUUIDFileRes_, getUUIDFileRes);
//    log4debug('renameFileRes: ' + BoolToStr(Result, true));
//  end;

//begin
//  upLog := '等待上传';
//  //renameFileRes;
//  if (calltype = CALLT_CALLIN) then begin           // 来电
//    g_FileDirProcess.addCurJsonFile(jsonFileName);
//  end else begin                                    //其他：去电
//    g_FileDirProcess.addCurJsonFile(jsonFileName);
//  end;
//  Result := true;
//end;

{class procedure TLocalRemoteCallEv.upload(const json: string);
var u: TLocalRemoteCallEv;
begin
//  TTask.Run(
//    procedure
//    begin
//      u := TLocalRemoteCallEv.fromJson(json);
//      try
//        u.upDataRes();
//      finally
//        if Assigned(u) then begin
//          u.Free;
//        end;
//      end;
//    end);
end;}

initialization
  g_LocalCallEv := TLocalRemoteCallEv.Create;
  p_LocalCallEv := @g_LocalCallEv;

finalization
  if Assigned(g_LocalCallEv) then begin
    g_LocalCallEv.Free;
  end;

end.
